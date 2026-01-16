#!/usr/bin/env python3
"""
飞书文档转产品设计规范工具
功能：从飞书文档链接提取内容，通过 Claude API 转换为标准化的 PRD Markdown 文档
"""

import os
import sys
import json
import requests
import argparse
from datetime import datetime
from typing import Optional, Dict, Any
import anthropic


class FeishuDocFetcher:
    """飞书文档获取器"""

    def __init__(self, app_id: str, app_secret: str):
        self.app_id = app_id
        self.app_secret = app_secret
        self.tenant_access_token = None

    def get_tenant_access_token(self) -> str:
        """获取飞书 tenant_access_token"""
        url = "https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal"
        headers = {"Content-Type": "application/json"}
        data = {
            "app_id": self.app_id,
            "app_secret": self.app_secret
        }

        response = requests.post(url, headers=headers, json=data)
        result = response.json()

        if result.get("code") == 0:
            self.tenant_access_token = result.get("tenant_access_token")
            return self.tenant_access_token
        else:
            raise Exception(f"获取 token 失败: {result.get('msg')}")

    def extract_doc_id(self, url: str) -> str:
        """从飞书文档链接中提取文档 ID"""
        # 支持多种飞书链接格式
        # https://xxx.feishu.cn/docx/xxxxx
        # https://xxx.feishu.cn/docs/xxxxx
        # https://xxx.feishu.cn/wiki/xxxxx

        if "/docx/" in url:
            return url.split("/docx/")[-1].split("?")[0]
        elif "/docs/" in url:
            return url.split("/docs/")[-1].split("?")[0]
        elif "/wiki/" in url:
            return url.split("/wiki/")[-1].split("?")[0]
        else:
            # 假设直接传入的是文档ID
            return url

    def get_doc_content(self, doc_url: str) -> Dict[str, Any]:
        """获取飞书文档内容"""
        if not self.tenant_access_token:
            self.get_tenant_access_token()

        doc_id = self.extract_doc_id(doc_url)

        # 获取文档原始内容
        url = f"https://open.feishu.cn/open-apis/docx/v1/documents/{doc_id}/raw_content"
        headers = {
            "Authorization": f"Bearer {self.tenant_access_token}",
            "Content-Type": "application/json"
        }

        response = requests.get(url, headers=headers)
        result = response.json()

        if result.get("code") == 0:
            return result.get("data", {})
        else:
            raise Exception(f"获取文档内容失败: {result.get('msg')}")


class ClaudePRDGenerator:
    """Claude PRD 生成器"""

    def __init__(self, api_key: str, prompt_template: str):
        self.client = anthropic.Anthropic(api_key=api_key)
        self.prompt_template = prompt_template

    def generate_prd(self, doc_content: str, doc_title: str = "") -> str:
        """使用 Claude 生成标准化的 PRD"""

        prompt = self.prompt_template.format(
            doc_title=doc_title,
            doc_content=doc_content,
            current_date=datetime.now().strftime("%Y-%m-%d")
        )

        message = self.client.messages.create(
            model="claude-sonnet-4-5-20250929",
            max_tokens=8000,
            temperature=0,
            messages=[{
                "role": "user",
                "content": prompt
            }]
        )

        return message.content[0].text


class PRDConverter:
    """PRD 转换器主类"""

    def __init__(self, config_path: str = "config.json"):
        self.config = self.load_config(config_path)
        self.feishu_fetcher = FeishuDocFetcher(
            app_id=self.config.get("feishu_app_id"),
            app_secret=self.config.get("feishu_app_secret")
        )

        # 加载 Prompt 模板
        with open(self.config.get("prompt_template_path", "prompt_template.txt"), "r", encoding="utf-8") as f:
            prompt_template = f.read()

        self.prd_generator = ClaudePRDGenerator(
            api_key=self.config.get("claude_api_key"),
            prompt_template=prompt_template
        )

    def load_config(self, config_path: str) -> Dict[str, Any]:
        """加载配置文件"""
        if os.path.exists(config_path):
            with open(config_path, "r", encoding="utf-8") as f:
                return json.load(f)
        else:
            # 尝试从环境变量读取
            return {
                "feishu_app_id": os.getenv("FEISHU_APP_ID"),
                "feishu_app_secret": os.getenv("FEISHU_APP_SECRET"),
                "claude_api_key": os.getenv("CLAUDE_API_KEY"),
                "output_dir": os.getenv("OUTPUT_DIR", "../doc"),
                "prompt_template_path": "prompt_template.txt"
            }

    def convert(self, feishu_url: str, output_filename: Optional[str] = None) -> str:
        """执行转换流程"""
        print(f"📄 正在获取飞书文档内容...")
        doc_data = self.feishu_fetcher.get_doc_content(feishu_url)
        doc_content = doc_data.get("content", "")
        doc_title = doc_data.get("title", "未命名文档")

        print(f"📝 文档标题: {doc_title}")
        print(f"🤖 正在使用 Claude 生成 PRD...")

        prd_content = self.prd_generator.generate_prd(doc_content, doc_title)

        # 保存到文件
        if not output_filename:
            # 使用文档标题作为文件名
            safe_title = "".join(c for c in doc_title if c.isalnum() or c in (' ', '-', '_')).strip()
            safe_title = safe_title.replace(' ', '-')
            output_filename = f"PRD-{safe_title}-{datetime.now().strftime('%Y%m%d')}.md"

        output_dir = self.config.get("output_dir", "../doc")
        os.makedirs(output_dir, exist_ok=True)

        output_path = os.path.join(output_dir, output_filename)
        with open(output_path, "w", encoding="utf-8") as f:
            f.write(prd_content)

        print(f"✅ PRD 已生成: {output_path}")
        return output_path


def main():
    parser = argparse.ArgumentParser(description="飞书文档转产品设计规范工具")
    parser.add_argument("url", help="飞书文档链接或文档ID")
    parser.add_argument("-o", "--output", help="输出文件名（可选）")
    parser.add_argument("-c", "--config", default="config.json", help="配置文件路径")

    args = parser.parse_args()

    try:
        converter = PRDConverter(config_path=args.config)
        output_path = converter.convert(args.url, args.output)
        print(f"\n🎉 转换完成！文件保存在: {output_path}")
    except Exception as e:
        print(f"❌ 错误: {str(e)}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
