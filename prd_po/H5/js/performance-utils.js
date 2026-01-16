// ========================================
// 虚拟滚动组件
// ========================================

/**
 * 虚拟滚动类 - 只渲染可见区域的元素
 * 适用于大数据量列表（1000+条）
 */
class VirtualScroll {
  constructor(options) {
    this.container = options.container; // 滚动容器
    this.items = options.items || []; // 数据源
    this.renderItem = options.renderItem; // 渲染函数
    this.itemHeight = options.itemHeight || 50; // 每项高度
    this.buffer = options.buffer || 5; // 缓冲区数量
    this.onItemClick = options.onItemClick; // 点击回调

    this.visibleCount = 0;
    this.startIndex = 0;
    this.endIndex = 0;

    this.init();
  }

  init() {
    // 计算可见数量
    this.visibleCount = Math.ceil(this.container.clientHeight / this.itemHeight) + this.buffer * 2;

    // 创建虚拟容器
    this.virtualContainer = document.createElement('div');
    this.virtualContainer.style.height = (this.items.length * this.itemHeight) + 'px';
    this.virtualContainer.style.position = 'relative';
    this.virtualContainer.className = 'virtual-scroll-container';

    // 创建实际渲染容器
    this.renderContainer = document.createElement('div');
    this.renderContainer.style.position = 'absolute';
    this.renderContainer.style.width = '100%';
    this.renderContainer.style.top = '0';
    this.renderContainer.className = 'virtual-scroll-render';

    this.virtualContainer.appendChild(this.renderContainer);
    this.container.innerHTML = '';
    this.container.appendChild(this.virtualContainer);

    // 监听滚动
    this.container.addEventListener('scroll', () => this.onScroll());

    this.render();
  }

  onScroll() {
    const scrollTop = this.container.scrollTop;
    const newStartIndex = Math.max(0, Math.floor(scrollTop / this.itemHeight) - this.buffer);

    if (newStartIndex !== this.startIndex) {
      this.startIndex = newStartIndex;
      this.render();
    }
  }

  render() {
    this.endIndex = Math.min(this.startIndex + this.visibleCount, this.items.length);
    const visibleItems = this.items.slice(this.startIndex, this.endIndex);

    this.renderContainer.style.top = (this.startIndex * this.itemHeight) + 'px';
    this.renderContainer.innerHTML = '';

    visibleItems.forEach((item, index) => {
      const realIndex = this.startIndex + index;
      const element = this.renderItem(item, realIndex);
      element.style.height = this.itemHeight + 'px';

      // 添加点击事件
      if (this.onItemClick) {
        element.addEventListener('click', (e) => {
          e.stopPropagation();
          this.onItemClick(item, realIndex, e);
        });
      }

      this.renderContainer.appendChild(element);
    });
  }

  update(items) {
    this.items = items;
    this.virtualContainer.style.height = (items.length * this.itemHeight) + 'px';
    this.startIndex = 0;
    this.container.scrollTop = 0;
    this.render();
  }

  scrollToTop() {
    this.container.scrollTop = 0;
    this.startIndex = 0;
    this.render();
  }

  destroy() {
    this.container.removeEventListener('scroll', this.onScroll);
    this.container.innerHTML = '';
  }
}

// ========================================
// 智能搜索组件
// ========================================

/**
 * 智能搜索类 - 带防抖和缓存
 */
class SmartSearch {
  constructor(options) {
    this.searchFn = options.searchFn; // 搜索函数
    this.debounceMs = options.debounceMs || 500; // 防抖延迟
    this.cacheSize = options.cacheSize || 50; // 缓存大小

    this.timer = null;
    this.cache = new Map();
    this.history = [];
  }

  search(query) {
    clearTimeout(this.timer);

    // 空查询直接返回
    if (!query || query.trim() === '') {
      return Promise.resolve(null);
    }

    query = query.trim().toLowerCase();

    // 检查缓存
    if (this.cache.has(query)) {
      return Promise.resolve(this.cache.get(query));
    }

    return new Promise((resolve) => {
      this.timer = setTimeout(async () => {
        try {
          const results = await this.searchFn(query);

          // 保存到缓存
          this.addToCache(query, results);

          // 保存到搜索历史
          this.addToHistory(query);

          resolve(results);
        } catch (error) {
          console.error('Search error:', error);
          resolve([]);
        }
      }, this.debounceMs);
    });
  }

  addToCache(query, results) {
    // 限制缓存大小
    if (this.cache.size >= this.cacheSize) {
      const firstKey = this.cache.keys().next().value;
      this.cache.delete(firstKey);
    }
    this.cache.set(query, results);
  }

  addToHistory(query) {
    // 去重
    this.history = this.history.filter(h => h !== query);
    this.history.unshift(query);

    // 限制历史记录数量
    if (this.history.length > 10) {
      this.history = this.history.slice(0, 10);
    }

    // 保存到localStorage
    try {
      localStorage.setItem('searchHistory', JSON.stringify(this.history));
    } catch (e) {
      console.warn('Failed to save search history');
    }
  }

  getHistory() {
    try {
      const history = localStorage.getItem('searchHistory');
      return history ? JSON.parse(history) : [];
    } catch (e) {
      return [];
    }
  }

  clearHistory() {
    this.history = [];
    localStorage.removeItem('searchHistory');
  }

  clearCache() {
    this.cache.clear();
  }
}

// ========================================
// 分页数据加载器
// ========================================

/**
 * 分页数据加载器 - 支持懒加载
 */
class PaginatedLoader {
  constructor(options) {
    this.loadFn = options.loadFn; // 加载函数
    this.pageSize = options.pageSize || 100; // 每页数量
    this.onLoad = options.onLoad; // 加载回调
    this.onError = options.onError; // 错误回调

    this.currentPage = 0;
    this.allData = [];
    this.hasMore = true;
    this.loading = false;
  }

  async loadMore() {
    if (!this.hasMore || this.loading) {
      return [];
    }

    this.loading = true;

    try {
      const data = await this.loadFn(this.currentPage, this.pageSize);

      this.allData.push(...data);
      this.currentPage++;

      if (data.length < this.pageSize) {
        this.hasMore = false;
      }

      if (this.onLoad) {
        this.onLoad(data, this.allData);
      }

      return data;
    } catch (error) {
      if (this.onError) {
        this.onError(error);
      }
      return [];
    } finally {
      this.loading = false;
    }
  }

  reset() {
    this.currentPage = 0;
    this.allData = [];
    this.hasMore = true;
    this.loading = false;
  }

  getData() {
    return this.allData;
  }

  getLoadedCount() {
    return this.allData.length;
  }

  isLoading() {
    return this.loading;
  }
}

// ========================================
// 选择项管理器
// ========================================

/**
 * 选择项管理器 - 管理已选项
 */
class SelectionManager {
  constructor(options) {
    this.container = options.container; // 显示容器
    this.idKey = options.idKey || 'id'; // ID字段名
    this.labelKey = options.labelKey || 'name'; // 标签字段名
    this.onChange = options.onChange; // 变更回调
    this.maxDisplay = options.maxDisplay || 10; // 最多显示数量

    this.selectedItems = new Map();
  }

  add(item) {
    const id = item[this.idKey];
    if (!this.selectedItems.has(id)) {
      this.selectedItems.set(id, item);
      this.render();
      if (this.onChange) {
        this.onChange(this.getAll());
      }
    }
  }

  remove(id) {
    if (this.selectedItems.has(id)) {
      this.selectedItems.delete(id);
      this.render();
      if (this.onChange) {
        this.onChange(this.getAll());
      }
    }
  }

  toggle(item) {
    const id = item[this.idKey];
    if (this.selectedItems.has(id)) {
      this.remove(id);
    } else {
      this.add(item);
    }
  }

  has(id) {
    return this.selectedItems.has(id);
  }

  getAll() {
    return Array.from(this.selectedItems.values());
  }

  clear() {
    this.selectedItems.clear();
    this.render();
    if (this.onChange) {
      this.onChange([]);
    }
  }

  getCount() {
    return this.selectedItems.size;
  }

  render() {
    if (!this.container) return;

    this.container.innerHTML = '';

    if (this.selectedItems.size === 0) {
      this.container.innerHTML = '<div style="color: var(--secondary); font-size: 14px;">暂无选择</div>';
      return;
    }

    const items = Array.from(this.selectedItems.values());
    const displayItems = items.slice(0, this.maxDisplay);
    const remainingCount = items.length - displayItems.length;

    displayItems.forEach(item => {
      const tag = document.createElement('span');
      tag.className = 'selection-tag';
      tag.innerHTML = `
        ${item[this.labelKey]}
        <span class="selection-tag-close" data-id="${item[this.idKey]}">×</span>
      `;

      tag.querySelector('.selection-tag-close').addEventListener('click', (e) => {
        e.stopPropagation();
        this.remove(item[this.idKey]);
      });

      this.container.appendChild(tag);
    });

    if (remainingCount > 0) {
      const moreTag = document.createElement('span');
      moreTag.className = 'selection-tag selection-tag-more';
      moreTag.textContent = `+${remainingCount}`;
      this.container.appendChild(moreTag);
    }
  }
}

// 导出
window.VirtualScroll = VirtualScroll;
window.SmartSearch = SmartSearch;
window.PaginatedLoader = PaginatedLoader;
window.SelectionManager = SelectionManager;
