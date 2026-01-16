# 广告批量创编 - UI设计规范

## 一、设计系统基础

### 1.1 色彩系统

#### 主色调（Primary Colors）
```
品牌蓝（主要操作）
├── Primary-6:  #1890FF  （主要按钮、链接）
├── Primary-5:  #40A9FF  （悬停状态）
├── Primary-7:  #096DD9  （点击状态）
├── Primary-1:  #E6F7FF  （浅色背景）
└── Primary-2:  #BAE7FF  （次要背景）
```

#### 功能色（Functional Colors）
```
成功绿
├── Success:    #52C41A
└── Success-bg: #F6FFED

警告橙
├── Warning:    #FAAD14
└── Warning-bg: #FFFBE6

错误红
├── Error:      #FF4D4F
└── Error-bg:   #FFF1F0

信息蓝
├── Info:       #1890FF
└── Info-bg:    #E6F7FF
```

#### 中性色（Neutral Colors）
```
文字色
├── Heading:    #262626  （标题）
├── Text:       #595959  （正文）
├── Secondary:  #8C8C8C  （次要文字）
└── Disabled:   #BFBFBF  （禁用文字）

背景色
├── White:      #FFFFFF  （纯白背景）
├── Gray-1:     #FAFAFA  （页面背景）
├── Gray-2:     #F5F5F5  （卡片背景）
├── Gray-3:     #E8E8E8  （分割线）
└── Gray-4:     #D9D9D9  （边框）
```

### 1.2 字体系统

#### 字体家族
```css
/* 中文字体 */
font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI',
             'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei',
             sans-serif;

/* 数字字体 */
font-family: 'SF Pro Display', 'Helvetica Neue', Arial, sans-serif;
```

#### 字号规范
```
H1 标题:    24px / 1.35     (页面主标题)
H2 标题:    20px / 1.4      (区块标题)
H3 标题:    16px / 1.5      (卡片标题)
H4 标题:    14px / 1.5      (小标题)

正文:       14px / 1.5      (主要内容)
辅助文字:   12px / 1.5      (说明文字)
小字:       11px / 1.5      (极小文字)
```

#### 字重规范
```
Regular:    400  (正文)
Medium:     500  (强调)
Semibold:   600  (标题)
Bold:       700  (重要标题)
```

### 1.3 间距系统

#### 基础间距单位：8px
```
Space-1:    4px   (极小间距)
Space-2:    8px   (小间距)
Space-3:    12px  (默认间距)
Space-4:    16px  (中等间距)
Space-5:    20px  (较大间距)
Space-6:    24px  (大间距)
Space-7:    32px  (超大间距)
Space-8:    40px  (巨大间距)
```

#### 应用场景
```
组件内边距:     16px / 20px
卡片间距:       16px
区块间距:       24px
页面边距:       24px / 32px
```

### 1.4 圆角系统

```
Radius-sm:   2px   (小元素：tag、badge)
Radius-md:   4px   (按钮、输入框)
Radius-lg:   8px   (卡片、弹窗)
Radius-xl:   12px  (大卡片)
Radius-full: 50%   (圆形头像、icon)
```

### 1.5 阴影系统

```css
/* 轻微阴影 */
box-shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.03),
               0 1px 6px -1px rgba(0, 0, 0, 0.02);

/* 默认阴影 */
box-shadow-md: 0 2px 8px rgba(0, 0, 0, 0.06),
               0 1px 4px rgba(0, 0, 0, 0.04);

/* 强阴影 */
box-shadow-lg: 0 4px 16px rgba(0, 0, 0, 0.08),
               0 2px 8px rgba(0, 0, 0, 0.06);

/* 悬浮阴影 */
box-shadow-xl: 0 8px 24px rgba(0, 0, 0, 0.12),
               0 4px 12px rgba(0, 0, 0, 0.08);
```

## 二、组件设计规范

### 2.1 按钮（Button）

#### 主要按钮（Primary Button）
```
尺寸:
├── Large:   40px 高度, 16px 24px 内边距
├── Default: 32px 高度, 12px 20px 内边距
└── Small:   24px 高度, 8px 16px 内边距

状态:
├── Default:  bg:#1890FF, text:#FFF
├── Hover:    bg:#40A9FF
├── Active:   bg:#096DD9
├── Disabled: bg:#F5F5F5, text:#BFBFBF
└── Loading:  带loading icon
```

#### 次要按钮（Default Button）
```
Default:  border:#D9D9D9, text:#595959
Hover:    border:#40A9FF, text:#40A9FF
Active:   border:#096DD9, text:#096DD9
```

#### 文字按钮（Text Button）
```
Default:  text:#1890FF
Hover:    text:#40A9FF, bg:#F5F5F5
Active:   text:#096DD9
```

#### 危险按钮（Danger Button）
```
Default:  bg:#FF4D4F, text:#FFF
Hover:    bg:#FF7875
Active:   bg:#D9363E
```

### 2.2 输入框（Input）

#### 文本输入框
```css
/* 默认状态 */
height: 32px;
padding: 4px 11px;
border: 1px solid #D9D9D9;
border-radius: 4px;
font-size: 14px;

/* 聚焦状态 */
border-color: #40A9FF;
box-shadow: 0 0 0 2px rgba(24, 144, 255, 0.2);

/* 错误状态 */
border-color: #FF4D4F;
box-shadow: 0 0 0 2px rgba(255, 77, 79, 0.2);

/* 禁用状态 */
background: #F5F5F5;
color: #BFBFBF;
cursor: not-allowed;
```

#### 文本域（Textarea）
```css
min-height: 80px;
padding: 8px 11px;
resize: vertical;
```

#### 输入框组合
```
┌──────────────────────────────────┐
│ 标签文字 *                        │
├──────────────────────────────────┤
│ ┌──────────────────────────────┐ │
│ │ 输入框                        │ │
│ └──────────────────────────────┘ │
│ 提示文字 / 错误提示               │
└──────────────────────────────────┘
```

### 2.3 选择器（Select）

```css
/* 下拉框 */
height: 32px;
border: 1px solid #D9D9D9;
border-radius: 4px;

/* 下拉面板 */
background: #FFFFFF;
box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
border-radius: 4px;
max-height: 256px;
overflow-y: auto;
```

#### 选项样式
```css
/* 选项 */
padding: 5px 12px;
cursor: pointer;

/* 悬停 */
background: #F5F5F5;

/* 选中 */
background: #E6F7FF;
color: #1890FF;
font-weight: 500;
```

### 2.4 复选框 & 单选框

#### 复选框（Checkbox）
```
尺寸: 16×16px
边框: 1px solid #D9D9D9
圆角: 2px

选中状态:
├── 背景: #1890FF
├── 边框: #1890FF
└── 勾选图标: 白色

禁用状态:
├── 背景: #F5F5F5
├── 边框: #D9D9D9
└── 勾选图标: #BFBFBF
```

#### 单选框（Radio）
```
尺寸: 16×16px
边框: 1px solid #D9D9D9
圆角: 50%

选中状态:
├── 边框: #1890FF (2px)
└── 内圆: #1890FF (6px)
```

### 2.5 开关（Switch）

```css
/* 默认尺寸 */
width: 44px;
height: 22px;
border-radius: 22px;

/* 关闭状态 */
background: rgba(0, 0, 0, 0.25);

/* 开启状态 */
background: #1890FF;

/* 滑块 */
width: 18px;
height: 18px;
background: #FFFFFF;
box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
```

### 2.6 标签（Tag）

```css
/* 默认标签 */
height: 22px;
padding: 0 8px;
border-radius: 2px;
font-size: 12px;
line-height: 20px;

/* 颜色变体 */
.tag-blue {
  background: #E6F7FF;
  color: #1890FF;
  border: 1px solid #91D5FF;
}

.tag-green {
  background: #F6FFED;
  color: #52C41A;
  border: 1px solid #B7EB8F;
}

.tag-orange {
  background: #FFF7E6;
  color: #FA8C16;
  border: 1px solid #FFD591;
}
```

### 2.7 表格（Table）

```css
/* 表头 */
.table-header {
  background: #FAFAFA;
  font-weight: 600;
  color: #262626;
  height: 48px;
  border-bottom: 1px solid #F0F0F0;
}

/* 表格行 */
.table-row {
  height: 48px;
  border-bottom: 1px solid #F0F0F0;
  transition: background 0.3s;
}

.table-row:hover {
  background: #FAFAFA;
}

/* 单元格 */
.table-cell {
  padding: 12px 16px;
  font-size: 14px;
  color: #595959;
}

/* 斑马纹（可选）*/
.table-row:nth-child(even) {
  background: #FAFAFA;
}
```

### 2.8 卡片（Card）

```css
.card {
  background: #FFFFFF;
  border-radius: 8px;
  border: 1px solid #E8E8E8;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.03);
  transition: box-shadow 0.3s;
}

.card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.card-header {
  padding: 16px 20px;
  border-bottom: 1px solid #F0F0F0;
  font-size: 16px;
  font-weight: 600;
}

.card-body {
  padding: 20px;
}
```

### 2.9 弹窗（Modal）

```css
/* 遮罩 */
.modal-mask {
  background: rgba(0, 0, 0, 0.45);
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 1000;
}

/* 弹窗容器 */
.modal {
  background: #FFFFFF;
  border-radius: 8px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
  max-width: 520px;
  width: 90%;
}

/* 弹窗头部 */
.modal-header {
  padding: 16px 24px;
  border-bottom: 1px solid #F0F0F0;
  font-size: 16px;
  font-weight: 600;
}

/* 弹窗内容 */
.modal-body {
  padding: 24px;
  max-height: 400px;
  overflow-y: auto;
}

/* 弹窗底部 */
.modal-footer {
  padding: 10px 16px;
  border-top: 1px solid #F0F0F0;
  text-align: right;
}
```

### 2.10 消息提示（Message / Toast）

```css
.message {
  position: fixed;
  top: 24px;
  left: 50%;
  transform: translateX(-50%);
  padding: 10px 16px;
  background: #FFFFFF;
  border-radius: 4px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  z-index: 2000;
  display: flex;
  align-items: center;
  gap: 8px;
}

/* 成功消息 */
.message-success {
  color: #52C41A;
}

/* 错误消息 */
.message-error {
  color: #FF4D4F;
}

/* 警告消息 */
.message-warning {
  color: #FAAD14;
}
```

### 2.11 进度条（Progress）

```css
/* 进度条容器 */
.progress {
  height: 8px;
  background: #F5F5F5;
  border-radius: 100px;
  overflow: hidden;
}

/* 进度条填充 */
.progress-bar {
  height: 100%;
  background: linear-gradient(to right, #1890FF, #40A9FF);
  border-radius: 100px;
  transition: width 0.3s ease;
}

/* 带百分比的进度条 */
.progress-text {
  margin-top: 4px;
  font-size: 12px;
  color: #8C8C8C;
  text-align: right;
}
```

### 2.12 步骤条（Steps）

```css
.steps {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.step {
  display: flex;
  flex-direction: column;
  align-items: center;
  position: relative;
}

/* 步骤图标 */
.step-icon {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: #F5F5F5;
  border: 2px solid #D9D9D9;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  color: #8C8C8C;
}

/* 已完成步骤 */
.step-finished .step-icon {
  background: #1890FF;
  border-color: #1890FF;
  color: #FFFFFF;
}

/* 当前步骤 */
.step-current .step-icon {
  background: #E6F7FF;
  border-color: #1890FF;
  color: #1890FF;
}

/* 连接线 */
.step-line {
  position: absolute;
  top: 16px;
  left: 50%;
  width: 100%;
  height: 2px;
  background: #F0F0F0;
}

.step-finished .step-line {
  background: #1890FF;
}
```

### 2.13 变量标签（Variable Tag）

```css
.variable-tag {
  display: inline-block;
  padding: 2px 8px;
  background: linear-gradient(135deg, #667EEA 0%, #764BA2 100%);
  color: #FFFFFF;
  border-radius: 4px;
  font-size: 12px;
  font-family: 'Monaco', 'Consolas', monospace;
  cursor: pointer;
  transition: all 0.3s;
}

.variable-tag:hover {
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(102, 126, 234, 0.4);
}
```

## 三、布局规范

### 3.1 页面布局

```
┌─────────────────────────────────────────────────┐
│  Header (64px)                                   │
├──────────┬──────────────────────────────────────┤
│          │                                       │
│  Sider   │  Content                             │
│  (256px) │  (flex-1)                            │
│          │                                       │
│          │                                       │
│          │                                       │
└──────────┴──────────────────────────────────────┘

内边距：24px
```

### 3.2 栅格系统

```
基于24列栅格系统
Container max-width: 1440px
Gutter: 16px

常用布局：
├── 12-12  (1/2 + 1/2)
├── 8-16   (1/3 + 2/3)
├── 6-18   (1/4 + 3/4)
└── 6-6-12 (1/4 + 1/4 + 1/2)
```

### 3.3 响应式断点

```
xs:  < 576px   (手机竖屏)
sm:  ≥ 576px   (手机横屏)
md:  ≥ 768px   (平板)
lg:  ≥ 992px   (桌面)
xl:  ≥ 1200px  (大屏桌面)
xxl: ≥ 1600px  (超大屏)

本项目最小支持：1366px
```

## 四、图标系统

### 4.1 图标规范

```
尺寸系列：
├── 12px  (极小图标)
├── 14px  (默认图标)
├── 16px  (中等图标)
├── 20px  (大图标)
└── 24px  (超大图标)

样式：
├── 线性图标 (stroke-width: 2px)
└── 面性图标 (填充样式)
```

### 4.2 常用图标

```
操作类：
├── 添加: plus-circle
├── 编辑: edit
├── 删除: delete
├── 保存: save
├── 搜索: search
├── 刷新: reload
└── 设置: setting

状态类：
├── 成功: check-circle (绿色)
├── 警告: exclamation-circle (橙色)
├── 错误: close-circle (红色)
└── 信息: info-circle (蓝色)

文件类：
├── 上传: upload
├── 下载: download
├── 导入: import
└── 导出: export
```

## 五、动效规范

### 5.1 过渡时间

```
快速: 0.1s  (按钮点击、开关切换)
默认: 0.3s  (大部分交互)
慢速: 0.5s  (页面切换、大型动画)
```

### 5.2 缓动函数

```css
/* 通用缓动 */
transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);

/* 进入 */
transition-timing-function: cubic-bezier(0, 0, 0.2, 1);

/* 离开 */
transition-timing-function: cubic-bezier(0.4, 0, 1, 1);
```

### 5.3 常用动画

```css
/* 淡入淡出 */
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

/* 从下滑入 */
@keyframes slideUp {
  from {
    transform: translateY(20px);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

/* 加载旋转 */
@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

/* 脉冲 */
@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}
```

## 六、特殊场景设计

### 6.1 空状态

```
┌────────────────────────────────┐
│                                 │
│         [空状态图标]            │
│                                 │
│       暂无数据                  │
│   点击按钮创建第一条广告        │
│                                 │
│      [+ 创建广告]               │
│                                 │
└────────────────────────────────┘

图标：灰色，64×64px
文字：#8C8C8C, 14px
按钮：主要按钮
```

### 6.2 加载状态

```css
/* 骨架屏 */
.skeleton {
  background: linear-gradient(
    90deg,
    #F5F5F5 25%,
    #E8E8E8 50%,
    #F5F5F5 75%
  );
  background-size: 200% 100%;
  animation: loading 1.5s infinite;
}

@keyframes loading {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}
```

### 6.3 错误状态

```
┌────────────────────────────────┐
│                                 │
│       [错误图标]                │
│                                 │
│    加载失败，请重试              │
│                                 │
│      [重新加载]                 │
│                                 │
└────────────────────────────────┘

图标：红色，64×64px
文字：#FF4D4F, 14px
```

## 七、辅助样式

### 7.1 工具类

```css
/* 间距 */
.m-0 { margin: 0; }
.mt-8 { margin-top: 8px; }
.mb-16 { margin-bottom: 16px; }
.p-16 { padding: 16px; }

/* 文字对齐 */
.text-left { text-align: left; }
.text-center { text-align: center; }
.text-right { text-align: right; }

/* 文字颜色 */
.text-primary { color: #1890FF; }
.text-success { color: #52C41A; }
.text-warning { color: #FAAD14; }
.text-error { color: #FF4D4F; }
.text-secondary { color: #8C8C8C; }

/* Flex布局 */
.flex { display: flex; }
.flex-center {
  display: flex;
  align-items: center;
  justify-content: center;
}
.flex-between {
  display: flex;
  justify-content: space-between;
}
```

### 7.2 隐藏类

```css
/* 视觉隐藏但保留DOM */
.visually-hidden {
  position: absolute;
  width: 1px;
  height: 1px;
  margin: -1px;
  padding: 0;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  border: 0;
}

/* 响应式隐藏 */
@media (max-width: 768px) {
  .hidden-mobile { display: none; }
}
```

## 八、设计交付物

### 8.1 设计文件
- Figma / Sketch 设计稿
- 组件库文件
- 图标库文件

### 8.2 开发资源
- CSS Variables 文件
- 组件样式库
- 图标字体/SVG Sprite
- 设计Token JSON

### 8.3 文档
- 组件使用说明
- 交互规范文档
- 无障碍设计指南

## 九、设计检查清单

### 上线前检查
- [ ] 所有交互状态都已设计（hover、active、disabled等）
- [ ] 响应式适配完成（至少支持1366px）
- [ ] 加载、空状态、错误状态都已覆盖
- [ ] 所有文案已审核（无错别字、语义清晰）
- [ ] 颜色对比度符合WCAG AA标准（4.5:1）
- [ ] 关键操作有二次确认
- [ ] 表单验证提示清晰明确
- [ ] 大数据场景已优化（虚拟滚动、分页）
- [ ] 动画性能良好（60fps）
- [ ] 键盘导航支持完整
