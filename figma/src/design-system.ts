import * as fs from 'fs';
import * as path from 'path';

export interface Color {
  main?: string;
  hover?: string;
  active?: string;
}

export interface TypographySize {
  size: number;
  lineHeight: number;
  weight: number;
}

export interface DesignSystem {
  colors: {
    primary: Color;
    functional: {
      success: string;
      warning: string;
      error: string;
    };
    neutral: {
      heading: string;
      text: string;
      secondary: string;
      disabled: string;
      white: string;
      gray1: string;
      gray2: string;
      gray3: string;
      gray4: string;
    };
  };
  typography: {
    fontFamily: string;
    sizes: {
      h1: TypographySize;
      h2: TypographySize;
      h3: TypographySize;
      body: TypographySize;
      caption: TypographySize;
    };
  };
  spacing: number[];
  radius: { sm: number; md: number; lg: number; xl: number };
  components: {
    button: { height: number; padding: string; radius: string };
    input: { height: number; padding: string; border: string };
    card: { padding: number; radius: string; shadow: string };
  };
}

export function loadDesignSystem(filePath?: string): DesignSystem {
  const defaultPath = path.join(__dirname, '../design-system.json');
  const targetPath = filePath || defaultPath;

  if (!fs.existsSync(targetPath)) {
    throw new Error(`Design system file not found: ${targetPath}`);
  }

  const content = fs.readFileSync(targetPath, 'utf-8');
  return JSON.parse(content) as DesignSystem;
}
