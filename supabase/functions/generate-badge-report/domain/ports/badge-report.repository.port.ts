/**
 * Badge Report Repository Port (Interface)
 */

import type { BadgeReportRow, BadgeReportFilters } from "../entities/badge-report.entity.ts";

export interface IBadgeReportRepository {
  findAll(filters: BadgeReportFilters): Promise<BadgeReportRow[]>;
}
