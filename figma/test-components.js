const fs = require('fs');
const path = require('path');
const { createDesignFromPRD } = require('./dist/tools/create-design.js');

async function testWithComponents() {
  console.log('🚀 测试完整的组件识别功能...\n');

  // 读取测试 PRD
  const testPrdPath = path.join(__dirname, 'tests/test-prd-with-components.md');
  const prdContent = fs.readFileSync(testPrdPath, 'utf-8');

  // 生成设计
  const result = await createDesignFromPRD({
    prd_content: prdContent,
    output_format: 'html'
  });

  if (result.isError) {
    console.error('❌ 生成失败:', result.content[0].text);
    process.exit(1);
  }

  console.log(result.content[0].text);
  console.log('\n✅ 测试完成!');
  console.log('\n📂 生成的文件: output/design-preview.html');
  console.log('💡 在浏览器中打开查看完整的设计预览!');
}

testWithComponents().catch(err => {
  console.error('测试失败:', err);
  process.exit(1);
});
