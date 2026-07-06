/**
 * Exchange Domain Entity
 */

export interface ExchangeRow {
  id: string;
  code: string | null;
  status: string;
  created_at: string;
  updated_at: string;
  company_name: string | null;
  user: { complete_name: string; email: string; employee_number: number | null } | null;
  reward: { name: string; points: number; category: string | null } | null;
}

export interface ExchangeReportFilters {
  status?: string;
  start_date?: string;
  end_date?: string;
  company_name?: string;
}
