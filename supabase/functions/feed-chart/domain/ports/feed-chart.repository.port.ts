/**
 * Feed Chart Repository Port (Interface)
 */

import type { AccountFeedForChart } from "../entities/feed-chart.entity.ts";

export interface IFeedChartRepository {
  findFeeds(startDate: Date, account?: number): Promise<AccountFeedForChart[]>;
}
