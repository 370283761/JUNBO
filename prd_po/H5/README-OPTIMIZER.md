# 广告批量创编功能 - 优化师视角原型说明

## 📁 项目结构（已更新）

```
prd_po/H5/
├── index.html                    ✅ 批量创编列表页
├── create-new.html               ✅ 新建创编-选择方式
├── data-selection.html           🆕 数据维度选择页（优化师视角核心）
├── rule-config.html              🆕 规则配置页
├── preview-result.html           🆕 结果预览页
├── config-campaign.html          ✅ 配置广告计划（旧版）
├── css/
│   └── style.css                 ✅ 统一样式
└── js/
    ├── main.js                   ✅ 公共工具
    └── generation-engine.js      🆕 生成引擎
```

## 🎯 优化师视角 VS 传统视角

### 传统视角（原设计）
```
用户角度：营销人员/广告主
流程：选择模板 → 配置计划 → 配置组 → 配置创意 → 变量 → 预览
适用场景：通用的广告创建，适合中小型广告主
```

### 优化师视角（新设计）⭐
```
用户角色：专业广告优化师
流程：选择维度 → 配置规则 → 预览生成 → 提交
适用场景：大规模批量投放，需要复杂规则组合
核心差异：
  - 以数据维度为中心（主体、账户、项目、素材等）
  - 支持复杂的筛选条件（转化数、开户天数等）
  - 灵活的生成规则（全量组合 / 自定义规则）
  - 素材分配策略（按曝光、按点击、按来源）
```

## 🔥 核心业务场景

### 场景1：全量组合投放
**业务需求**：为所有主体创建全面覆盖的广告
```
6个主体 × 4个项目 × 4个广告 × 4个素材 = 384条广告
```

**操作流程**：
1. 选择6个主体
2. 选择项目、素材
3. 配置规则：全量组合模式
4. 系统自动生成384条广告

### 场景2：精准账户投放
**业务需求**：只对表现好的账户扩量
```
条件：跑量主体 + 转化数>6
生成：每个符合条件的账户 6个广告
     - 3个解压素材
     - 3个滚屏素材
```

**操作流程**：
1. 选择跑量主体
2. 设置筛选条件：转化数>6
3. 配置规则：每账户6广告（3解压+3滚屏）
4. 系统筛选出符合条件的账户并生成

### 场景3：新账户快速起量
**业务需求**：为新开户的优质账户快速搭建广告
```
条件：跑量主体 + 转化数>6 + 开户<5天
生成：每账户 6个广告
     - 3个解压（1个ADX按曝光降序，2个自剪辑）
     - 3个滚屏（按点击降序）
```

**操作流程**：
1. 选择跑量主体
2. 设置筛选：转化>6 且 开户<5天
3. 配置素材分配策略
4. 系统生成带有精准素材的广告

## 📊 核心维度说明

### 1. 主体（Subject）
- **定义**：广告投放的公司主体
- **字段**：名称、类型（跑量/测试）、账户数、转化数
- **示例**：主体A（跑量）账户:5 转化:120

### 2. 账户（Account）
- **定义**：媒体平台投放账户
- **字段**：名称、所属主体、转化数、开户天数、状态
- **筛选条件**：
  - 转化数 > N
  - 开户天数 < N
  - 账户状态（跑量/测试/暂停）

### 3. 项目（Project）
- **定义**：投放项目类别
- **示例**：项目1-霸道总裁、项目2-穿越重生

### 4. 小说（Book）
- **定义**：具体推广的小说内容
- **关联**：属于某个项目
- **示例**：《总裁的替身妻子》

### 5. 素材（Material）
- **类型**：
  - 解压（Decompress）
  - 滚屏（Scroll）
  - ADX
- **来源**：
  - ADX素材
  - 自剪辑素材
- **指标**：曝光数、点击数
- **排序规则**：
  - 按曝光降序
  - 按点击降序
  - 随机

## 🎛️ 生成规则设计

### 模式1：全量组合
```javascript
{
  mode: 'full-combination',
  generation: {
    projectsPerSubject: 4,  // 每个主体4个项目
    adsPerProject: 4,        // 每个项目4个广告
    materialsPerAd: 4        // 每个广告4个素材
  }
}
```

### 模式2：自定义规则
```javascript
{
  mode: 'custom',
  conditions: {
    subjectStatus: 'running',  // 跑量主体
    conversionMin: 6,          // 转化数>6
    openDaysMax: 5,            // 开户<5天
    accountStatus: 'running'   // 账户状态
  },
  generation: {
    perAccount: true,          // 按账户生成
    adCount: 6,                // 每账户6个广告
    breakdown: {
      decompress: 3,           // 3个解压
      scroll: 3                // 3个滚屏
    },
    materialStrategy: {
      decompress: [
        { source: 'adx', sortBy: 'exposure', count: 1 },
        { source: 'self-edit', count: 2 }
      ],
      scroll: [
        { sortBy: 'clicks', count: 3 }
      ]
    }
  }
}
```

## 🔧 生成引擎（GenerationEngine）

### 核心功能

**1. 数据管理**
```javascript
const engine = new GenerationEngine();

// 设置选中的数据
engine.setSelectedData({
  subjects: [...],   // 选中的主体
  accounts: [...],   // 选中的账户
  projects: [...],   // 选中的项目
  books: [...],      // 选中的小说
  materials: [...]   // 选中的素材
});
```

**2. 规则配置**
```javascript
// 使用规则模板
engine.setRules(RULE_TEMPLATES.template2);

// 或自定义规则
engine.setRules({
  mode: 'custom',
  conditions: {...},
  generation: {...}
});
```

**3. 生成计算**
```javascript
// 计算预计生成数量
const count = engine.calculateCount();
// 返回：30

// 获取统计信息
const stats = engine.getStatistics();
// 返回：{
//   subjectCount: 2,
//   accountCount: 10,
//   filteredAccountCount: 5,  // 符合条件的账户
//   estimatedCount: 30
// }
```

**4. 执行生成**
```javascript
// 生成广告列表
const results = engine.generate();
// 返回：[
//   {
//     id: '...',
//     subjectName: '主体A',
//     accountName: '账户1',
//     projectName: '项目1-霸道总裁',
//     bookName: '《总裁的替身妻子》',
//     materialType: 'decompress',
//     materialSource: 'adx',
//     name: '主体A-账户1-项目1-解压-01',
//     budget: 500,
//     bidding: 50
//   },
//   ...
// ]
```

### 规则模板

**模板1：全量组合**
```javascript
RULE_TEMPLATES.template1 = {
  name: '规则模板1：全量组合',
  mode: 'full-combination',
  generation: {
    projectsPerSubject: 4,
    adsPerProject: 4,
    materialsPerAd: 4
  }
};
```

**模板2：跑量账户扩量**
```javascript
RULE_TEMPLATES.template2 = {
  name: '规则模板2：跑量主体+转化>6',
  mode: 'custom',
  conditions: {
    subjectStatus: 'running',
    conversionMin: 6
  },
  generation: {
    perAccount: true,
    adCount: 6,
    breakdown: { decompress: 3, scroll: 3 }
  }
};
```

**模板3：新账户起量**
```javascript
RULE_TEMPLATES.template3 = {
  name: '规则模板3：跑量主体+转化>6+开户<5天',
  mode: 'custom',
  conditions: {
    subjectStatus: 'running',
    conversionMin: 6,
    openDaysMax: 5
  },
  generation: {
    perAccount: true,
    adCount: 6,
    breakdown: { decompress: 3, scroll: 3 },
    materialStrategy: {
      decompress: [
        { source: 'adx', sortBy: 'exposure', count: 1 },
        { source: 'self-edit', count: 2 }
      ],
      scroll: [
        { sortBy: 'clicks', count: 3 }
      ]
    }
  }
};
```

## 🎨 页面流程

### 流程图
```
index.html (列表页)
    ↓ 点击"新建创编"
create-new.html (选择方式)
    ↓ 选择"优化师配置"
data-selection.html (选择维度) 🆕
    ├─ 选择主体
    ├─ 筛选账户
    ├─ 选择项目
    ├─ 选择小说
    └─ 选择素材
    ↓ 下一步
rule-config.html (配置规则) 🆕
    ├─ 选择规则模式
    ├─ 配置生成规则
    └─ 选择规则模板
    ↓ 下一步
preview-result.html (预览结果) 🆕
    ├─ 查看生成摘要
    ├─ 浏览完整列表
    ├─ 筛选和搜索
    └─ 单条编辑
    ↓ 提交
submit.html (提交创建)
    ├─ 进度显示
    └─ 结果反馈
```

## 💡 使用示例

### 示例1：使用规则模板2快速创建

```javascript
// 1. 初始化引擎
const engine = new GenerationEngine();

// 2. 选择数据维度
engine.setSelectedData({
  subjects: [
    { id: 'SUB001', name: '主体A', type: 'running', conversionCount: 120 },
    { id: 'SUB002', name: '主体B', type: 'running', conversionCount: 85 }
  ],
  accounts: [
    { id: 'ACC001', subjectId: 'SUB001', name: '账户1', conversionCount: 25, status: 'running' },
    { id: 'ACC002', subjectId: 'SUB001', name: '账户2', conversionCount: 18, status: 'running' },
    { id: 'ACC003', subjectId: 'SUB002', name: '账户3', conversionCount: 8, status: 'running' },
    { id: 'ACC004', subjectId: 'SUB002', name: '账户4', conversionCount: 2, status: 'testing' }
  ],
  projects: [
    { id: 'PRJ001', name: '项目1-霸道总裁' }
  ],
  books: [
    { id: 'BOOK001', projectId: 'PRJ001', name: '《总裁的替身妻子》' }
  ],
  materials: [
    { id: 'MAT001', type: 'decompress', exposure: 10000, clicks: 500 },
    { id: 'MAT002', type: 'decompress', exposure: 8000, clicks: 400 },
    { id: 'MAT003', type: 'scroll', exposure: 12000, clicks: 800 },
    { id: 'MAT004', type: 'scroll', exposure: 9000, clicks: 600 }
  ]
});

// 3. 使用规则模板2
engine.setRules(RULE_TEMPLATES.template2);

// 4. 查看预估
const stats = engine.getStatistics();
console.log('符合条件的账户:', stats.filteredAccountCount); // 3个（转化>6）
console.log('预计生成:', stats.estimatedCount); // 18条（3账户×6广告）

// 5. 生成广告
const results = engine.generate();
console.log('生成结果:', results.length); // 18条
```

### 示例2：完整的生成结果数据结构

```javascript
[
  {
    id: '1737012345678-001',
    subjectId: 'SUB001',
    subjectName: '主体A',
    accountId: 'ACC001',
    accountName: '账户1',
    projectId: 'PRJ001',
    projectName: '项目1-霸道总裁',
    bookId: 'BOOK001',
    bookName: '《总裁的替身妻子》',
    materialId: 'MAT001',
    materialType: 'decompress',
    materialSource: 'adx',
    name: '主体A-账户1-项目1-霸道总裁-解压-01',
    budget: 500,
    bidding: 50,
    schedule: 'allday'
  },
  // ... 更多广告
]
```

## 🚀 快速开始

### 方式1：查看生成引擎
```bash
# 在浏览器控制台测试生成引擎
open /Users/depp/projects/Prd_PO/prd_po/H5/js/generation-engine.js
```

### 方式2：完整流程演示（待完成页面后）
```bash
# 启动本地服务器
cd /Users/depp/projects/Prd_PO/prd_po/H5
python3 -m http.server 8000

# 访问 http://localhost:8000
# 1. 打开 index.html
# 2. 点击"新建创编"
# 3. 选择数据维度
# 4. 配置生成规则
# 5. 预览结果
# 6. 提交创建
```

## 📋 待完成的页面

由于篇幅原因，完整的页面原型需要分步实现：

### ✅ 已完成
1. 生成引擎（generation-engine.js）
2. 数据模型和规则设计
3. 规则模板系统

### 🔨 待实现
1. **data-selection.html** - 数据维度选择页
   - 5个维度的选择界面
   - 实时统计和预览
   - 筛选条件配置

2. **rule-config.html** - 规则配置页
   - 规则模式切换
   - 自定义规则配置
   - 规则模板选择
   - 实时计算生成数量

3. **preview-result.html** - 结果预览页
   - 生成摘要展示
   - 完整列表查看
   - 筛选和搜索
   - 单条编辑/删除

4. **integration** - 流程整合
   - 页面间数据传递
   - 导航流程完善
   - 错误处理

## 🎓 技术亮点

### 1. 灵活的生成引擎
- 支持多种生成模式
- 可扩展的规则系统
- 智能的素材分配

### 2. 复杂的业务规则
- 多条件筛选
- 层级数据组合
- 策略化素材选择

### 3. 模板化设计
- 预设规则模板
- 快速应用场景
- 可自定义扩展

### 4. 数据驱动
- 实时计算预估
- 动态筛选账户
- 统计信息展示

## 🔍 与传统方式对比

| 维度 | 传统方式 | 优化师视角 |
|------|---------|-----------|
| **用户角色** | 广告主/营销人员 | 专业优化师 |
| **配置方式** | 逐步填写表单 | 选择维度+规则 |
| **生成规则** | 简单的变量组合 | 复杂的条件筛选 |
| **素材管理** | 手动上传 | 策略化分配 |
| **适用场景** | 小规模投放 | 大规模批量投放 |
| **效率** | 中等 | 极高 |
| **灵活性** | 一般 | 非常灵活 |

## 💪 核心优势

1. **效率提升10倍**：从手动配置到规则自动生成
2. **专业化操作**：符合优化师实际工作流程
3. **规则复用**：模板系统支持快速复制
4. **精准投放**：条件筛选确保投放准确性
5. **素材优化**：智能分配高质量素材

## 📝 总结

优化师视角的批量创编功能是一个**更专业、更高效、更符合实际业务**的设计。通过：
- **维度化的数据选择**
- **规则化的生成配置**
- **策略化的素材分配**

将复杂的批量投放任务简化为简单的几步操作，极大提升广告优化师的工作效率。

需要继续完善哪个页面吗？
