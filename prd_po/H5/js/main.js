// ========================================
// 广告批量创编 - 公共JavaScript
// ========================================

// 数据存储管理
const DataStore = {
  // 保存数据到localStorage
  save(key, value) {
    try {
      localStorage.setItem(key, JSON.stringify(value));
    } catch (e) {
      console.error('保存数据失败:', e);
    }
  },

  // 从localStorage读取数据
  load(key, defaultValue = null) {
    try {
      const data = localStorage.getItem(key);
      return data ? JSON.parse(data) : defaultValue;
    } catch (e) {
      console.error('读取数据失败:', e);
      return defaultValue;
    }
  },

  // 删除数据
  remove(key) {
    localStorage.removeItem(key);
  },

  // 清空所有数据
  clear() {
    localStorage.clear();
  }
};

// 模态框管理
class Modal {
  constructor(modalId) {
    this.modal = document.getElementById(modalId);
    this.mask = this.modal?.querySelector('.modal-mask') || this.modal;
    this.closeBtn = this.modal?.querySelector('.modal-close');

    if (this.closeBtn) {
      this.closeBtn.addEventListener('click', () => this.hide());
    }

    // 点击遮罩关闭
    if (this.mask) {
      this.mask.addEventListener('click', (e) => {
        if (e.target === this.mask) {
          this.hide();
        }
      });
    }
  }

  show() {
    if (this.mask) {
      this.mask.classList.add('active');
      document.body.style.overflow = 'hidden';
    }
  }

  hide() {
    if (this.mask) {
      this.mask.classList.remove('active');
      document.body.style.overflow = '';
    }
  }
}

// 消息提示
const Message = {
  show(text, type = 'info', duration = 3000) {
    const message = document.createElement('div');
    message.className = `message message-${type}`;

    const icons = {
      success: '✓',
      error: '✗',
      warning: '⚠',
      info: 'ℹ'
    };

    message.innerHTML = `
      <span class="message-icon">${icons[type] || icons.info}</span>
      <span class="message-text">${text}</span>
    `;

    // 添加样式
    Object.assign(message.style, {
      position: 'fixed',
      top: '24px',
      left: '50%',
      transform: 'translateX(-50%)',
      padding: '10px 16px',
      background: '#FFFFFF',
      borderRadius: '4px',
      boxShadow: '0 4px 12px rgba(0, 0, 0, 0.15)',
      zIndex: '2000',
      display: 'flex',
      alignItems: 'center',
      gap: '8px',
      animation: 'slideUp 0.3s'
    });

    document.body.appendChild(message);

    setTimeout(() => {
      message.style.opacity = '0';
      message.style.transform = 'translateX(-50%) translateY(-20px)';
      setTimeout(() => {
        document.body.removeChild(message);
      }, 300);
    }, duration);
  },

  success(text, duration) {
    this.show(text, 'success', duration);
  },

  error(text, duration) {
    this.show(text, 'error', duration);
  },

  warning(text, duration) {
    this.show(text, 'warning', duration);
  },

  info(text, duration) {
    this.show(text, 'info', duration);
  }
};

// 表单验证
const Validator = {
  // 验证必填项
  required(value, message = '此项为必填项') {
    if (!value || value.trim() === '') {
      return message;
    }
    return null;
  },

  // 验证数字
  number(value, message = '请输入有效的数字') {
    if (value && isNaN(value)) {
      return message;
    }
    return null;
  },

  // 验证范围
  range(value, min, max, message) {
    const num = parseFloat(value);
    if (num < min || num > max) {
      return message || `请输入${min}到${max}之间的数字`;
    }
    return null;
  },

  // 验证URL
  url(value, message = '请输入有效的URL') {
    if (value) {
      try {
        new URL(value);
      } catch (e) {
        return message;
      }
    }
    return null;
  }
};

// 防抖函数
function debounce(func, wait = 300) {
  let timeout;
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout);
      func(...args);
    };
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
  };
}

// 节流函数
function throttle(func, wait = 300) {
  let inThrottle;
  return function(...args) {
    if (!inThrottle) {
      func.apply(this, args);
      inThrottle = true;
      setTimeout(() => inThrottle = false, wait);
    }
  };
}

// 生成唯一ID
function generateId() {
  return Date.now().toString(36) + Math.random().toString(36).substr(2);
}

// 格式化日期
function formatDate(date, format = 'YYYY-MM-DD') {
  const d = new Date(date);
  const year = d.getFullYear();
  const month = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');

  return format
    .replace('YYYY', year)
    .replace('MM', month)
    .replace('DD', day);
}

// 获取当前日期
function getCurrentDate() {
  return formatDate(new Date());
}

// 变量替换
function replaceVariables(template, variables) {
  let result = template;
  for (const [key, value] of Object.entries(variables)) {
    const regex = new RegExp(`\\{${key}\\}`, 'g');
    result = result.replace(regex, value);
  }
  return result;
}

// 解析变量
function parseVariables(text) {
  const regex = /\{([^}]+)\}/g;
  const variables = new Set();
  let match;
  while ((match = regex.exec(text)) !== null) {
    variables.add(match[1]);
  }
  return Array.from(variables);
}

// 导出到全局
window.DataStore = DataStore;
window.Modal = Modal;
window.Message = Message;
window.Validator = Validator;
window.debounce = debounce;
window.throttle = throttle;
window.generateId = generateId;
window.formatDate = formatDate;
window.getCurrentDate = getCurrentDate;
window.replaceVariables = replaceVariables;
window.parseVariables = parseVariables;
