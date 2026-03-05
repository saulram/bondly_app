/**
 * Refill Repository Implementation
 * Infrastructure adapter for monthly refill
 */

import type { SupabaseClient } from "@supabase/supabase-js";
import type { IRefillRepository } from "../../domain/ports/refill.repository.port.ts";
import type { RefillResult } from "../../domain/entities/refill.entity.ts";

export class RefillRepository implements IRefillRepository {
  constructor(private readonly client: SupabaseClient) {}

  async executeMonthlyRefill(): Promise<RefillResult> {
    const { data, error } = await this.client.rpc("monthly_points_refill");

    if (error) {
      throw new Error(error.message);
    }

    return data as RefillResult;
  }
}
