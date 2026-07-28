/**
 * Treemap Repository Implementation
 * Infrastructure adapter for treemap data access
 */

import type { SupabaseClient } from "@supabase/supabase-js";
import type { ITreemapRepository } from "../../domain/ports/treemap.repository.port.ts";
import type { BadgeReportForTreemap, TreemapFilters } from "../../domain/entities/treemap.entity.ts";

export class TreemapRepository implements ITreemapRepository {
  constructor(private readonly client: SupabaseClient) {}

  async findBadgeReports(filters: TreemapFilters): Promise<BadgeReportForTreemap[]> {
    let query = this.client
      .from("badge_reports")
      .select(`
        badge_id,
        category_id,
        badge:badges(name, value),
        category:badge_categories(name)
      `);

    if (filters.start_date) {
      query = query.gte("created_at", filters.start_date);
    }

    if (filters.end_date) {
      query = query.lte("created_at", filters.end_date);
    }

    const { data, error } = await query;

    if (error) {
      throw new Error(error.message);
    }

    return (data as unknown as BadgeReportForTreemap[]) ?? [];
  }
}
