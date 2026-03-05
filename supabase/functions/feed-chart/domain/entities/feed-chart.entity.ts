/**
 * Feed Chart Domain Entities
 */

export interface ChartSummary {
  type: string;
  label: string;
  count: number;
}

export interface DailyData {
  date: string;
  [key: string]: string | number;
}

export interface FeedChartResponse {
  summary: ChartSummary[];
  daily: DailyData[];
  total: number;
}

export interface AccountFeedForChart {
  id: string;
  type: string | null;
  created_at: string;
}

export interface FeedChartFilters {
  account?: number;
  days?: number;
}

export const FEED_TYPE_LABELS: Record<string, string> = {
  reconocimiento: "Reconocimientos",
  canje: "Canjes",
  comentario: "Comentarios",
  recompensa: "Recompensas",
  otro: "Otros",
};
