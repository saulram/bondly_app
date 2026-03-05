/**
 * Badge Report Domain Entity
 */

export interface BadgeReportRow {
  id: string;
  created_at: string;
  badge: { name: string; value: number } | null;
  category: { name: string } | null;
  sender: { complete_name: string; email: string } | null;
  receiver: { complete_name: string; email: string } | null;
  sender_profile: { job_position: string; job_area: string } | null;
  receiver_profile: { job_position: string; job_area: string } | null;
}

export interface BadgeReportFilters {
  badge_id?: string;
  category_id?: string;
  start_date?: string;
  end_date?: string;
  account?: number;
}
