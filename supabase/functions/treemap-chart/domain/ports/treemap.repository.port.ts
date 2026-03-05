/**
 * Treemap Repository Port (Interface)
 */

import type { BadgeReportForTreemap, TreemapFilters } from "../entities/treemap.entity.ts";

export interface ITreemapRepository {
  findBadgeReports(filters: TreemapFilters): Promise<BadgeReportForTreemap[]>;
}
