/**
 * Area Chart Repository Port (Interface)
 */

import type { AcknowledgmentForChart } from "../entities/area-chart.entity.ts";

export interface IAreaChartRepository {
  findAcknowledgments(
    startDate: Date,
    endDate: Date,
    account?: number
  ): Promise<AcknowledgmentForChart[]>;
}
