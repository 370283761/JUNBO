// ========================================
// 广告批量创编 - 生成引擎
// ========================================

/**
 * 生成引擎类
 * 负责根据选择的维度和规则生成广告计划
 */
class GenerationEngine {
  constructor() {
    this.selectedData = {
      subjects: [],
      accounts: [],
      projects: [],
      books: [],
      materials: []
    };
    this.rules = null;
  }

  /**
   * 设置选中的数据维度
   */
  setSelectedData(data) {
    this.selectedData = { ...this.selectedData, ...data };
  }

  /**
   * 设置生成规则
   */
  setRules(rules) {
    this.rules = rules;
  }

  /**
   * 计算预计生成数量
   */
  calculateCount() {
    if (!this.rules) return 0;

    const { mode, generation } = this.rules;

    if (mode === 'full-combination') {
      // 全量组合模式
      const { subjectsPerCampaign, projectsPerSubject, adsPerProject, materialsPerAd } = generation;
      return this.selectedData.subjects.length *
             (projectsPerSubject || 1) *
             (adsPerProject || 1) *
             (materialsPerAd || 1);
    } else if (mode === 'custom') {
      // 自定义规则模式
      const { perAccount, adCount } = generation;

      if (perAccount) {
        // 按账户生成
        const filteredAccounts = this.filterAccounts();
        return filteredAccounts.length * adCount;
      }
    }

    return 0;
  }

  /**
   * 根据条件筛选账户
   */
  filterAccounts() {
    if (!this.rules || !this.rules.conditions) {
      return this.selectedData.accounts;
    }

    const { subjectStatus, conversionMin, openDaysMax, accountStatus } = this.rules.conditions;

    return this.selectedData.accounts.filter(account => {
      // 筛选主体状态
      if (subjectStatus) {
        const subject = this.selectedData.subjects.find(s => s.id === account.subjectId);
        if (subject && subject.type !== subjectStatus) return false;
      }

      // 筛选转化数
      if (conversionMin && account.conversionCount < conversionMin) {
        return false;
      }

      // 筛选开户天数
      if (openDaysMax && account.openDays > openDaysMax) {
        return false;
      }

      // 筛选账户状态
      if (accountStatus && account.status !== accountStatus) {
        return false;
      }

      return true;
    });
  }

  /**
   * 分配素材
   */
  allocateMaterials(type, strategy) {
    let materials = this.selectedData.materials.filter(m => m.type === type);

    if (!strategy || materials.length === 0) {
      return materials.slice(0, strategy?.count || 1);
    }

    // 按来源筛选
    if (strategy.source) {
      materials = materials.filter(m => m.source === strategy.source);
    }

    // 排序
    if (strategy.sortBy === 'exposure') {
      materials.sort((a, b) => b.exposure - a.exposure);
    } else if (strategy.sortBy === 'clicks') {
      materials.sort((a, b) => b.clicks - a.clicks);
    } else if (strategy.sortBy === 'random') {
      materials.sort(() => Math.random() - 0.5);
    }

    return materials.slice(0, strategy.count || 1);
  }

  /**
   * 生成广告计划列表
   */
  generate() {
    if (!this.rules) {
      throw new Error('未配置生成规则');
    }

    const results = [];
    const { mode, generation } = this.rules;

    if (mode === 'full-combination') {
      // 全量组合模式
      results.push(...this.generateFullCombination(generation));
    } else if (mode === 'custom') {
      // 自定义规则模式
      results.push(...this.generateCustom(generation));
    }

    return results;
  }

  /**
   * 全量组合生成
   */
  generateFullCombination(generation) {
    const results = [];
    const { projectsPerSubject, adsPerProject, materialsPerAd } = generation;

    for (const subject of this.selectedData.subjects) {
      const subjectProjects = this.selectedData.projects.slice(0, projectsPerSubject);

      for (const project of subjectProjects) {
        const projectBooks = this.selectedData.books.filter(b => b.projectId === project.id);

        for (let adIndex = 0; adIndex < adsPerProject; adIndex++) {
          const adMaterials = this.selectedData.materials.slice(
            adIndex * materialsPerAd,
            (adIndex + 1) * materialsPerAd
          );

          for (const material of adMaterials) {
            results.push({
              id: generateId(),
              subjectId: subject.id,
              subjectName: subject.name,
              accountId: null,
              accountName: '-',
              projectId: project.id,
              projectName: project.name,
              bookId: projectBooks[0]?.id || null,
              bookName: projectBooks[0]?.name || '-',
              materialId: material.id,
              materialType: material.type,
              materialSource: material.source,
              name: `${subject.name}-${project.name}-${material.type}-${String(adIndex + 1).padStart(2, '0')}`,
              budget: 500,
              bidding: 50,
              schedule: 'allday'
            });
          }
        }
      }
    }

    return results;
  }

  /**
   * 自定义规则生成
   */
  generateCustom(generation) {
    const results = [];
    const { perAccount, adCount, breakdown, materialStrategy } = generation;

    if (perAccount) {
      // 按账户生成
      const filteredAccounts = this.filterAccounts();

      for (const account of filteredAccounts) {
        const subject = this.selectedData.subjects.find(s => s.id === account.subjectId);
        const project = this.selectedData.projects[0]; // 简化：使用第一个项目
        const book = this.selectedData.books.find(b => b.projectId === project?.id);

        // 生成解压素材广告
        if (breakdown.decompress > 0) {
          const decompressMaterials = this.allocateMaterialsForType(
            'decompress',
            materialStrategy.decompress,
            breakdown.decompress
          );

          for (let i = 0; i < decompressMaterials.length; i++) {
            const material = decompressMaterials[i];
            results.push({
              id: generateId(),
              subjectId: subject?.id,
              subjectName: subject?.name || '-',
              accountId: account.id,
              accountName: account.name,
              projectId: project?.id,
              projectName: project?.name || '-',
              bookId: book?.id,
              bookName: book?.name || '-',
              materialId: material.id,
              materialType: material.type,
              materialSource: material.source,
              name: `${subject?.name}-${account.name}-${project?.name}-解压-${String(i + 1).padStart(2, '0')}`,
              budget: 500,
              bidding: 50,
              schedule: 'allday'
            });
          }
        }

        // 生成滚屏素材广告
        if (breakdown.scroll > 0) {
          const scrollMaterials = this.allocateMaterialsForType(
            'scroll',
            materialStrategy.scroll,
            breakdown.scroll
          );

          for (let i = 0; i < scrollMaterials.length; i++) {
            const material = scrollMaterials[i];
            results.push({
              id: generateId(),
              subjectId: subject?.id,
              subjectName: subject?.name || '-',
              accountId: account.id,
              accountName: account.name,
              projectId: project?.id,
              projectName: project?.name || '-',
              bookId: book?.id,
              bookName: book?.name || '-',
              materialId: material.id,
              materialType: material.type,
              materialSource: material.source,
              name: `${subject?.name}-${account.name}-${project?.name}-滚屏-${String(i + 1).padStart(2, '0')}`,
              budget: 500,
              bidding: 50,
              schedule: 'allday'
            });
          }
        }
      }
    }

    return results;
  }

  /**
   * 为特定类型分配素材
   */
  allocateMaterialsForType(type, strategies, count) {
    let allocated = [];

    if (!strategies || strategies.length === 0) {
      // 没有策略，随机选择
      const materials = this.selectedData.materials.filter(m => m.type === type);
      return materials.slice(0, count);
    }

    for (const strategy of strategies) {
      const materials = this.allocateMaterials(type, strategy);
      allocated.push(...materials);
      if (allocated.length >= count) break;
    }

    return allocated.slice(0, count);
  }

  /**
   * 获取统计信息
   */
  getStatistics() {
    return {
      subjectCount: this.selectedData.subjects.length,
      accountCount: this.selectedData.accounts.length,
      projectCount: this.selectedData.projects.length,
      bookCount: this.selectedData.books.length,
      materialCount: this.selectedData.materials.length,
      filteredAccountCount: this.filterAccounts().length,
      estimatedCount: this.calculateCount()
    };
  }
}

// 规则模板
const RULE_TEMPLATES = {
  template1: {
    name: '规则模板1：全量组合',
    description: '6个主体×4项目×4广告×4素材',
    mode: 'full-combination',
    generation: {
      projectsPerSubject: 4,
      adsPerProject: 4,
      materialsPerAd: 4
    }
  },
  template2: {
    name: '规则模板2：跑量主体+转化>6',
    description: '每账户6广告(3解压+3滚屏)',
    mode: 'custom',
    conditions: {
      subjectStatus: 'running',
      conversionMin: 6,
      accountStatus: 'running'
    },
    generation: {
      perAccount: true,
      adCount: 6,
      breakdown: {
        decompress: 3,
        scroll: 3
      },
      materialStrategy: {
        decompress: [
          { sortBy: 'exposure', count: 3 }
        ],
        scroll: [
          { sortBy: 'clicks', count: 3 }
        ]
      }
    }
  },
  template3: {
    name: '规则模板3：跑量主体+转化>6+开户<5天',
    description: '每账户6广告(3解压+3滚屏)',
    mode: 'custom',
    conditions: {
      subjectStatus: 'running',
      conversionMin: 6,
      openDaysMax: 5,
      accountStatus: 'running'
    },
    generation: {
      perAccount: true,
      adCount: 6,
      breakdown: {
        decompress: 3,
        scroll: 3
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
};

// 导出
window.GenerationEngine = GenerationEngine;
window.RULE_TEMPLATES = RULE_TEMPLATES;
