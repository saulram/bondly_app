/**
 * Area Chart Repository Implementation
 * Infrastructure adapter for area chart data access
 */

import type { SupabaseClient } from "@supabase/supabase-js";
import type { IAreaChartRepository } from "../../domain/ports/area-chart.repository.port.ts";
import type { AcknowledgmentForChart } from "../../domain/entities/area-chart.entity.ts";

export class AreaChartRepository implements IAreaChartRepository {
  constructor(private readonly client: SupabaseClient) {}

  async findAcknowledgments(
    startDate: Date,
    endDate: Date,
    account?: number
  ): Promise<AcknowledgmentForChart[]> {
    let query = this.client
      .from("acknowledgments")
      .select(`
        id,
        created_at,
        badge:badges(value)
      `)
      .gte("created_at", startDate.toISOString())
      .lte("created_at", endDate.toISOString())
      .eq("visible", true);

    if (account) {
      query = query.eq("account", account);
    }

    const { data, error } = await query;

    if (error) {
      throw new Error(error.message);
    }

    return (data as unknown as AcknowledgmentForChart[]) ?? [];
  }
}
