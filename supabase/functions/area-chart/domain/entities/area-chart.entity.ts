/**
 * Area Chart Domain Entities
 */

export interface ChartDataPoint {
  month: string;
  label: string;
  count: number;
  points: number;
}

export interface AcknowledgmentForChart {
  id: string;
  created_at: string;
  badge: { value: number } | null;
}

export interface AreaChartFilters {
  months?: number;
  account?: number;
}
