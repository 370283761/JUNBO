import { parsePRD } from '../prd-parser';
import { loadDesignSystem } from '../design-system';
import { generateHTMLPreview, saveHTMLPreview } from '../html-generator';
import * as path from 'path';
import * as fs from 'fs';

export async function createDesignFromPRD(args: any) {
  const { prd_content, output_format = 'html', design_system_path } = args;

  try {
    // 1. 加载设计系统
    const designSystem = loadDesignSystem(design_system_path);

    // 2. 解析 PRD
    const pages = parsePRD(prd_content);

    if (pages.length === 0) {
      throw new Error('未能从 PRD 中解析出有效页面,请检查 PRD 格式');
    }

    // 3. 生成输出
    const outputDir = path.join(__dirname, '../../output');
    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    const results: string[] = [];

    // 生成 HTML 预览
    if (output_format === 'html' || output_format === 'both') {
      const html = generateHTMLPreview(pages, designSystem);
      const htmlPath = path.join(outputDir, 'design-preview.html');
      saveHTMLPreview(html, htmlPath);
      results.push(`✅ HTML 预览: ${htmlPath}`);
    }

    // 生成 Figma Plugin 代码 (TODO)
    if (output_format === 'figma-plugin' || output_format === 'both') {
      results.push(`ℹ️  Figma Plugin 代码生成功能即将推出`);
    }

    // 4. 返回结果
    const totalComponents = pages.reduce((sum, p) => sum + p.components.length, 0);

    return {
      content: [{
        type: 'text',
        text: `
🎉 设计稿生成成功!

📊 解析结果:
- 识别页面数: ${pages.length}
- 总组件数: ${totalComponents}

📝 页面列表:
${pages.map((p, i) => `${i + 1}. ${p.name} (${p.components.length} 个组件)`).join('\n')}

📁 生成文件:
${results.join('\n')}

🌐 查看设计:
在浏览器中打开 HTML 文件即可查看完整设计预览
        `.trim()
      }]
    };

  } catch (error: any) {
    return {
      content: [{
        type: 'text',
        text: `❌ 生成失败: ${error.message}\n\n堆栈信息:\n${error.stack || '无'}`
      }],
      isError: true
    };
  }
}
