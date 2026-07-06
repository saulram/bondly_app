/**
 * Exchange Repository Implementation
 * Infrastructure adapter for exchange data access
 */

import type { SupabaseClient } from "@supabase/supabase-js";
import type { IExchangeRepository } from "../../domain/ports/exchange.repository.port.ts";
import type { ExchangeRow, ExchangeReportFilters } from "../../domain/entities/exchange.entity.ts";

export class ExchangeRepository implements IExchangeRepository {
  constructor(private readonly client: SupabaseClient) {}

  async findAll(filters: ExchangeReportFilters): Promise<ExchangeRow[]> {
    let query = this.client
      .from("exchanges")
      .select(`
        id,
        code,
        status,
        created_at,
        updated_at,
        company_name,
        user:users(complete_name, email, employee_number),
        reward:rewards(name, points, category)
      `)
      .order("created_at", { ascending: false });

    if (filters.status) {
      query = query.eq("status", filters.status);
    }

    if (filters.start_date) {
      query = query.gte("created_at", filters.start_date);
    }

    if (filters.end_date) {
      query = query.lte("created_at", filters.end_date);
    }

    if (filters.company_name) {
      query = query.eq("company_name", filters.company_name);
    }

    const { data, error } = await query;

    if (error) {
      throw new Error(error.message);
    }

    return (data as unknown as ExchangeRow[]) ?? [];
  }
}
