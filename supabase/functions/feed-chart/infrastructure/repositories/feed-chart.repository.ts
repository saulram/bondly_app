/**
 * Feed Chart Repository Implementation
 * Infrastructure adapter for feed chart data access
 */

import type { SupabaseClient } from "@supabase/supabase-js";
import type { IFeedChartRepository } from "../../domain/ports/feed-chart.repository.port.ts";
import type { AccountFeedForChart } from "../../domain/entities/feed-chart.entity.ts";

export class FeedChartRepository implements IFeedChartRepository {
  constructor(private readonly client: SupabaseClient) {}

  async findFeeds(startDate: Date, account?: number): Promise<AccountFeedForChart[]> {
    let query = this.client
      .from("account_feeds")
      .select("id, type, created_at")
      .gte("created_at", startDate.toISOString())
      .eq("visible", true);

    if (account) {
      query = query.eq("account", account);
    }

    const { data, error } = await query;

    if (error) {
      throw new Error(error.message);
    }

    return (data as unknown as AccountFeedForChart[]) ?? [];
  }
}
