export interface PageStructure {
  name: string;
  description?: string;
  components: ComponentDef[];
}

export interface ComponentDef {
  type: 'header' | 'button' | 'input' | 'card' | 'text' | 'container';
  content?: string;
  properties?: Record<string, any>;
}

export function parsePRD(prdContent: string): PageStructure[] {
  const pages: PageStructure[] = [];

  // 简化实现: 提取二级标题作为页面
  const sections = prdContent.split(/^## /gm).filter(s => s.trim());

  for (const section of sections) {
    const lines = section.split('\n');
    const pageName = lines[0].trim();

    const page: PageStructure = {
      name: pageName,
      components: extractComponents(section)
    };

    pages.push(page);
  }

  return pages;
}

function extractComponents(content: string): ComponentDef[] {
  const components: ComponentDef[] = [];

  // 识别常见关键词
  const keywords = [
    { pattern: /按钮|button/i, type: 'button' as const },
    { pattern: /输入框|input|文本框/i, type: 'input' as const },
    { pattern: /卡片|card/i, type: 'card' as const }
  ];

  // 提取列表项
  const items = content.match(/^[-*]\s+(.+)/gm) || [];

  for (const item of items) {
    const text = item.replace(/^[-*]\s+/, '').trim();

    for (const kw of keywords) {
      if (kw.pattern.test(text)) {
        components.push({
          type: kw.type,
          content: text
        });
        break;
      }
    }
  }

  return components;
}
