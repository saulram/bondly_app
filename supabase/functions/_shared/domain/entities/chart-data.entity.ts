/**
 * Chart Data Entities - Domain models for visualizations
 */

export interface TreemapNode {
  name: string;
  value?: number;
  points?: number;
  children?: TreemapNode[];
}

export interface TimeSeriesDataPoint {
  period: string;
  label: string;
  count: number;
  points: number;
}

export interface FeedChartSummary {
  type: string;
  label: string;
  count: number;
}

export interface FeedChartDaily {
  date: string;
  [key: string]: string | number;
}

export interface FeedChartData {
  summary: FeedChartSummary[];
  daily: FeedChartDaily[];
  total: number;
}

export type FeedType = "reconocimiento" | "canje" | "comentario" | "recompensa";

export const FEED_TYPE_LABELS: Record<string, string> = {
  reconocimiento: "Reconocimientos",
  canje: "Canjes",
  comentario: "Comentarios",
  recompensa: "Recompensas",
  otro: "Otros",
};
