/**
 * Generate Treemap Use Case
 * Application layer business logic
 */

import type { ITreemapRepository } from "../../domain/ports/treemap.repository.port.ts";
import type { TreemapNode, TreemapFilters } from "../../domain/entities/treemap.entity.ts";

export class GenerateTreemapUseCase {
  constructor(private readonly repository: ITreemapRepository) {}

  async execute(filters: TreemapFilters): Promise<TreemapNode> {
    const reports = await this.repository.findBadgeReports(filters);

    // Aggregate data for treemap
    const categoryMap = new Map<
      string,
      { name: string; badges: Map<string, { name: string; count: number; value: number }> }
    >();

    for (const report of reports) {
      const categoryId = report.category_id;
      const categoryName = report.category?.name ?? "Sin categoría";
      const badgeId = report.badge_id;
      const badgeName = report.badge?.name ?? "Sin insignia";
      const badgeValue = report.badge?.value ?? 0;

      if (!categoryMap.has(categoryId)) {
        categoryMap.set(categoryId, { name: categoryName, badges: new Map() });
      }

      const category = categoryMap.get(categoryId)!;
      if (!category.badges.has(badgeId)) {
        category.badges.set(badgeId, { name: badgeName, count: 0, value: badgeValue });
      }

      const badge = category.badges.get(badgeId)!;
      badge.count++;
    }

    // Build treemap data structure
    const treemapData: TreemapNode = {
      name: "Reconocimientos",
      children: Array.from(categoryMap.values()).map((category) => ({
        name: category.name,
        children: Array.from(category.badges.values()).map((badge) => ({
          name: badge.name,
          value: badge.count,
          points: badge.value * badge.count,
        })),
      })),
    };

    return treemapData;
  }
}
