#!/usr/bin/env node
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema
} from '@modelcontextprotocol/sdk/types.js';
import { createDesignFromPRD } from './tools/create-design.js';

const server = new Server({
  name: 'figma-mcp-server',
  version: '1.0.0',
}, {
  capabilities: {
    tools: {},
  },
});

// 列出可用工具
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: 'create_design_from_prd',
        description: '从 PRD 文档自动生成 Figma 设计稿(HTML预览 + Plugin代码)',
        inputSchema: {
          type: 'object',
          properties: {
            prd_content: {
              type: 'string',
              description: 'PRD 文档完整内容'
            },
            output_format: {
              type: 'string',
              enum: ['html', 'figma-plugin', 'both'],
              default: 'html',
              description: '输出格式: html(HTML预览), figma-plugin(Plugin代码), both(两者)'
            },
            design_system_path: {
              type: 'string',
              description: 'UI设计规范文件路径(可选,默认使用内置规范)'
            }
          },
          required: ['prd_content']
        }
      }
    ]
  };
});

// 处理工具调用
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  if (name === 'create_design_from_prd') {
    return await createDesignFromPRD(args);
  }

  throw new Error(`Unknown tool: ${name}`);
});

// 启动服务器
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error('Figma MCP Server started successfully');
}

main().catch((error) => {
  console.error('Failed to start server:', error);
  process.exit(1);
});
