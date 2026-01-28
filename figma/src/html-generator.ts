import * as fs from 'fs';
import { PageStructure, ComponentDef } from './prd-parser';
import { DesignSystem } from './design-system';

export function generateHTMLPreview(pages: PageStructure[], ds: DesignSystem): string {
  return `<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>设计预览 - ${pages[0]?.name || '产品设计'}</title>
  <style>${generateCSS(ds)}</style>
</head>
<body>
  <div class="container">
    <aside class="sidebar">
      <h3>页面导航</h3>
      ${pages.map((p, i) => `<a href="#page-${i}">${escapeHtml(p.name)}</a>`).join('\n      ')}
    </aside>
    <main class="content">
      ${pages.map((p, i) => generatePage(p, i, ds)).join('\n      ')}
    </main>
  </div>
  <script>
    document.querySelectorAll('.sidebar a').forEach(link => {
      link.addEventListener('click', (e) => {
        e.preventDefault();
        const target = document.querySelector(link.getAttribute('href'));
        if (target) {
          target.scrollIntoView({ behavior: 'smooth' });
          document.querySelectorAll('.sidebar a').forEach(a => a.classList.remove('active'));
          link.classList.add('active');
        }
      });
    });
    if (document.querySelectorAll('.sidebar a').length > 0) {
      document.querySelectorAll('.sidebar a')[0].classList.add('active');
    }
  </script>
</body>
</html>`;
}

function generateCSS(ds: DesignSystem): string {
  return `
* { margin: 0; padding: 0; box-sizing: border-box; }
body {
  font-family: ${ds.typography.fontFamily};
  background: ${ds.colors.neutral.gray1};
  color: ${ds.colors.neutral.text};
}
.container { display: flex; height: 100vh; }
.sidebar {
  width: 256px;
  background: ${ds.colors.neutral.white};
  padding: 24px;
  border-right: 1px solid ${ds.colors.neutral.gray3};
  overflow-y: auto;
}
.sidebar h3 {
  font-size: ${ds.typography.sizes.h3.size}px;
  font-weight: ${ds.typography.sizes.h3.weight};
  color: ${ds.colors.neutral.heading};
  margin-bottom: 16px;
}
.sidebar a {
  display: block;
  padding: 8px 12px;
  margin-bottom: 4px;
  text-decoration: none;
  color: ${ds.colors.neutral.text};
  border-radius: ${ds.radius.md}px;
  transition: all 0.2s;
}
.sidebar a:hover {
  background: ${ds.colors.neutral.gray2};
}
.sidebar a.active {
  background: ${ds.colors.primary.main};
  color: ${ds.colors.neutral.white};
}
.content {
  flex: 1;
  padding: 40px;
  overflow-y: auto;
}
.page {
  background: ${ds.colors.neutral.white};
  padding: ${ds.spacing[6]}px;
  margin-bottom: 40px;
  border-radius: ${ds.radius.lg}px;
  box-shadow: ${ds.components.card.shadow};
  min-height: 400px;
}
.page h2 {
  font-size: ${ds.typography.sizes.h2.size}px;
  font-weight: ${ds.typography.sizes.h2.weight};
  color: ${ds.colors.neutral.heading};
  margin-bottom: 24px;
  padding-bottom: 12px;
  border-bottom: 2px solid ${ds.colors.neutral.gray2};
}
.button {
  display: inline-block;
  padding: ${ds.components.button.padding};
  background: ${ds.colors.primary.main};
  color: ${ds.colors.neutral.white};
  border: none;
  border-radius: ${ds.radius.md}px;
  margin: 8px 8px 8px 0;
  cursor: pointer;
  font-size: ${ds.typography.sizes.body.size}px;
  transition: all 0.2s;
}
.button:hover {
  background: ${ds.colors.primary.hover};
  transform: translateY(-1px);
}
.button:active {
  background: ${ds.colors.primary.active};
  transform: translateY(0);
}
.input {
  display: block;
  width: 100%;
  max-width: 400px;
  height: ${ds.components.input.height}px;
  padding: ${ds.components.input.padding};
  border: ${ds.components.input.border};
  border-radius: ${ds.radius.md}px;
  margin: 8px 0;
  font-size: ${ds.typography.sizes.body.size}px;
  transition: all 0.2s;
}
.input:focus {
  outline: none;
  border-color: ${ds.colors.primary.main};
  box-shadow: 0 0 0 2px rgba(24, 144, 255, 0.1);
}
.card {
  padding: ${ds.components.card.padding}px;
  border: 1px solid ${ds.colors.neutral.gray3};
  border-radius: ${ds.radius.lg}px;
  margin: 16px 0;
  box-shadow: ${ds.components.card.shadow};
  transition: all 0.2s;
}
.card:hover {
  box-shadow: 0 4px 16px rgba(0,0,0,0.1);
  transform: translateY(-2px);
}
.component-label {
  display: inline-block;
  font-size: ${ds.typography.sizes.caption.size}px;
  color: ${ds.colors.neutral.secondary};
  margin-bottom: 4px;
  font-weight: 500;
}
  `.trim();
}

function generatePage(page: PageStructure, index: number, ds: DesignSystem): string {
  const componentsHTML = page.components.length > 0
    ? page.components.map(c => generateComponent(c)).join('\n        ')
    : '<p style="color: #8C8C8C; font-style: italic;">此页面暂无组件</p>';

  return `
      <div id="page-${index}" class="page">
        <h2>${escapeHtml(page.name)}</h2>
        ${componentsHTML}
      </div>`;
}

function generateComponent(c: ComponentDef): string {
  const label = `<span class="component-label">[${c.type.toUpperCase()}]</span>`;

  switch (c.type) {
    case 'button':
      return `<div>${label}<br/><button class="button">${escapeHtml(c.content || '按钮')}</button></div>`;
    case 'input':
      return `<div>${label}<br/><input class="input" placeholder="${escapeHtml(c.content || '请输入')}" /></div>`;
    case 'card':
      return `<div class="card">${label}<br/><strong>${escapeHtml(c.content || '卡片内容')}</strong></div>`;
    case 'text':
      return `<p>${label} ${escapeHtml(c.content || '')}</p>`;
    default:
      return `<p>${label} ${escapeHtml(c.content || '')}</p>`;
  }
}

function escapeHtml(text: string): string {
  const map: Record<string, string> = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#039;'
  };
  return text.replace(/[&<>"']/g, m => map[m]);
}

export function saveHTMLPreview(html: string, outputPath: string): void {
  fs.writeFileSync(outputPath, html, 'utf-8');
}
