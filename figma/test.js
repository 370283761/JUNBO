const fs = require('fs');
const path = require('path');

// 导入生成函数
const { createDesignFromPRD } = require('./dist/tools/create-design.js');

// 读取 PRD 内容
const prdPath = path.join(__dirname, '../prd_po/广告批量创编功能PRD.md');
const prdContent = fs.readFileSync(prdPath, 'utf-8');

// 调用生成函数
async function test() {
  console.log('🚀 开始生成设计预览...\n');

  const result = await createDesignFromPRD({
    prd_content: prdContent,
    output_format: 'html'
  });

  // 输出结果
  if (result.isError) {
    console.error('❌ 生成失败:', result.content[0].text);
  } else {
    console.log(result.content[0].text);
    console.log('\n✅ 测试完成!');
  }
}

test().catch(err => {
  console.error('测试失败:', err);
  process.exit(1);
});
