// Figma Plugin 核心代码
// 这段代码需要在 Figma 的 Plugin 编辑器中运行

// 从 MCP Server 获取的设计数据
interface DesignData {
  pages: Array<{
    name: string;
    components: Array<{
      type: 'button' | 'input' | 'card' | 'text';
      content: string;
      properties?: any;
    }>;
  }>;
  designSystem: {
    colors: any;
    typography: any;
    spacing: number[];
    radius: any;
    components: any;
  };
}

// 主函数
async function generateDesign(data: DesignData) {
  console.log('开始在 Figma 中生成设计...');

  const { pages, designSystem } = data;

  // 为每个页面创建 Frame
  for (let i = 0; i < pages.length; i++) {
    const pageData = pages[i];

    // 创建 Page
    const page = figma.createPage();
    page.name = pageData.name;

    // 创建主 Frame
    const mainFrame = figma.createFrame();
    mainFrame.name = pageData.name;
    mainFrame.resize(1440, 1024);
    mainFrame.x = 0;
    mainFrame.y = 0;
    mainFrame.fills = [{ type: 'SOLID', color: hexToRgb(designSystem.colors.neutral.white) }];

    let currentY = designSystem.spacing[6]; // 24px

    // 创建页面标题
    const title = await createText(pageData.name, {
      fontSize: designSystem.typography.sizes.h2.size,
      fontWeight: designSystem.typography.sizes.h2.weight,
      color: designSystem.colors.neutral.heading
    });
    title.x = designSystem.spacing[6];
    title.y = currentY;
    mainFrame.appendChild(title);
    currentY += title.height + designSystem.spacing[5];

    // 创建组件
    for (const component of pageData.components) {
      const node = await createComponent(component, designSystem);
      if (node) {
        node.x = designSystem.spacing[6];
        node.y = currentY;
        mainFrame.appendChild(node);
        currentY += node.height + designSystem.spacing[4];
      }
    }

    page.appendChild(mainFrame);
    figma.viewport.scrollAndZoomIntoView([mainFrame]);
  }

  figma.notify('✅ 设计稿生成完成!');
  figma.closePlugin();
}

// 创建组件
async function createComponent(component: any, ds: any): Promise<SceneNode | null> {
  switch (component.type) {
    case 'button':
      return await createButton(component, ds);
    case 'input':
      return await createInput(component, ds);
    case 'card':
      return await createCard(component, ds);
    case 'text':
      return await createText(component.content, {
        fontSize: ds.typography.sizes.body.size,
        color: ds.colors.neutral.text
      });
    default:
      return null;
  }
}

// 创建按钮
async function createButton(component: any, ds: any): Promise<FrameNode> {
  const button = figma.createFrame();
  button.name = 'Button';
  button.resize(120, ds.components.button.height);
  button.cornerRadius = ds.radius[ds.components.button.radius];
  button.fills = [{ type: 'SOLID', color: hexToRgb(ds.colors.primary.main) }];

  // 加载字体
  await figma.loadFontAsync({ family: 'Inter', style: 'Regular' });

  const text = figma.createText();
  text.characters = component.content || '按钮';
  text.fontSize = ds.typography.sizes.body.size;
  text.fills = [{ type: 'SOLID', color: { r: 1, g: 1, b: 1 } }];

  // 居中文本
  text.x = (button.width - text.width) / 2;
  text.y = (button.height - text.height) / 2;

  button.appendChild(text);
  return button;
}

// 创建输入框
async function createInput(component: any, ds: any): Promise<FrameNode> {
  const input = figma.createFrame();
  input.name = 'Input';
  input.resize(300, ds.components.input.height);
  input.cornerRadius = ds.radius.md;
  input.fills = [{ type: 'SOLID', color: hexToRgb(ds.colors.neutral.white) }];
  input.strokes = [{ type: 'SOLID', color: hexToRgb(ds.colors.neutral.gray4) }];
  input.strokeWeight = 1;

  await figma.loadFontAsync({ family: 'Inter', style: 'Regular' });

  const placeholder = figma.createText();
  placeholder.characters = component.content || '请输入';
  placeholder.fontSize = ds.typography.sizes.body.size;
  placeholder.fills = [{ type: 'SOLID', color: hexToRgb(ds.colors.neutral.secondary) }];
  placeholder.x = 11;
  placeholder.y = (input.height - placeholder.height) / 2;

  input.appendChild(placeholder);
  return input;
}

// 创建卡片
async function createCard(component: any, ds: any): Promise<FrameNode> {
  const card = figma.createFrame();
  card.name = 'Card';
  card.resize(400, 120);
  card.cornerRadius = ds.radius[ds.components.card.radius];
  card.fills = [{ type: 'SOLID', color: hexToRgb(ds.colors.neutral.white) }];
  card.effects = [{
    type: 'DROP_SHADOW',
    color: { r: 0, g: 0, b: 0, a: 0.06 },
    offset: { x: 0, y: 2 },
    radius: 8,
    visible: true
  }];

  await figma.loadFontAsync({ family: 'Inter', style: 'Semi Bold' });

  const title = figma.createText();
  title.characters = component.content || '卡片内容';
  title.fontSize = ds.typography.sizes.h3.size;
  title.fontName = { family: 'Inter', style: 'Semi Bold' };
  title.fills = [{ type: 'SOLID', color: hexToRgb(ds.colors.neutral.heading) }];
  title.x = ds.components.card.padding;
  title.y = ds.components.card.padding;

  card.appendChild(title);
  return card;
}

// 创建文本
async function createText(content: string, options: any): Promise<TextNode> {
  await figma.loadFontAsync({ family: 'Inter', style: 'Regular' });

  const text = figma.createText();
  text.characters = content;
  text.fontSize = options.fontSize || 14;
  text.fills = [{ type: 'SOLID', color: hexToRgb(options.color || '#595959') }];

  return text;
}

// 工具函数: 十六进制颜色转 RGB
function hexToRgb(hex: string): RGB {
  const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
  return result ? {
    r: parseInt(result[1], 16) / 255,
    g: parseInt(result[2], 16) / 255,
    b: parseInt(result[3], 16) / 255
  } : { r: 0, g: 0, b: 0 };
}

// 导出函数,供 UI 调用
(globalThis as any).generateDesign = generateDesign;
