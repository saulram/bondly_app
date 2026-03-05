/**
 * Treemap Domain Entities
 */

export interface TreemapNode {
  name: string;
  value?: number;
  points?: number;
  children?: TreemapNode[];
}

export interface BadgeReportForTreemap {
  badge_id: string;
  category_id: string;
  badge: { name: string; value: number } | null;
  category: { name: string } | null;
}

export interface TreemapFilters {
  start_date?: string;
  end_date?: string;
}
