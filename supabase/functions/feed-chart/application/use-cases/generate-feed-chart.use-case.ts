/**
 * Generate Feed Chart Use Case
 * Application layer business logic
 */

import type { IFeedChartRepository } from "../../domain/ports/feed-chart.repository.port.ts";
import type {
  ChartSummary,
  DailyData,
  FeedChartResponse,
  FeedChartFilters,
} from "../../domain/entities/feed-chart.entity.ts";
import { FEED_TYPE_LABELS } from "../../domain/entities/feed-chart.entity.ts";

export class GenerateFeedChartUseCase {
  constructor(private readonly repository: IFeedChartRepository) {}

  async execute(filters: FeedChartFilters): Promise<FeedChartResponse> {
    const days = filters.days ?? 30;

    // Calculate start date
    const startDate = new Date();
    startDate.setDate(startDate.getDate() - days);

    const feeds = await this.repository.findFeeds(startDate, filters.account);

    // Aggregate by type
    const typeCount = new Map<string, number>();

    for (const feed of feeds) {
      const type = feed.type ?? "otro";
      typeCount.set(type, (typeCount.get(type) ?? 0) + 1);
    }

    // Build summary
    const summary: ChartSummary[] = Array.from(typeCount.entries()).map(([type, count]) => ({
      type,
      label: FEED_TYPE_LABELS[type] ?? type,
      count,
    }));

    // Aggregate by day
    const dailyData = new Map<string, Record<string, number>>();

    for (const feed of feeds) {
      const date = new Date(feed.created_at).toISOString().split("T")[0];
      const type = feed.type ?? "otro";

      if (!dailyData.has(date)) {
        dailyData.set(date, {});
      }

      const dayData = dailyData.get(date)!;
      dayData[type] = (dayData[type] ?? 0) + 1;
    }

    // Convert to array and sort
    const daily: DailyData[] = Array.from(dailyData.entries())
      .map(([date, types]) => ({ date, ...types }))
      .sort((a, b) => a.date.localeCompare(b.date));

    return {
      summary,
      daily,
      total: feeds.length,
    };
  }
}
