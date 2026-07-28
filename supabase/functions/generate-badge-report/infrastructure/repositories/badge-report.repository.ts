/**
 * Badge Report Repository Implementation
 * Infrastructure adapter for badge report data access
 */

import type { SupabaseClient } from "@supabase/supabase-js";
import type { IBadgeReportRepository } from "../../domain/ports/badge-report.repository.port.ts";
import type { BadgeReportRow, BadgeReportFilters } from "../../domain/entities/badge-report.entity.ts";

export class BadgeReportRepository implements IBadgeReportRepository {
  constructor(private readonly client: SupabaseClient) {}

  async findAll(filters: BadgeReportFilters): Promise<BadgeReportRow[]> {
    let query = this.client
      .from("badge_reports")
      .select(`
        id,
        created_at,
        badge:badges(name, value),
        category:badge_categories(name),
        sender:users!sender_id(complete_name, email),
        receiver:users!receiver_id(complete_name, email),
        sender_profile:user_profiles!sender_profile_id(job_position, job_area),
        receiver_profile:user_profiles!receiver_profile_id(job_position, job_area)
      `)
      .order("created_at", { ascending: false });

    if (filters.badge_id) {
      query = query.eq("badge_id", filters.badge_id);
    }

    if (filters.category_id) {
      query = query.eq("category_id", filters.category_id);
    }

    if (filters.start_date) {
      query = query.gte("created_at", filters.start_date);
    }

    if (filters.end_date) {
      query = query.lte("created_at", filters.end_date);
    }

    const { data, error } = await query;

    if (error) {
      throw new Error(error.message);
    }

    return (data as unknown as BadgeReportRow[]) ?? [];
  }
}
