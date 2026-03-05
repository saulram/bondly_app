/**
 * Supabase Database Adapter - Infrastructure implementation of IDatabasePort
 */

import { createClient, SupabaseClient } from "@supabase/supabase-js";
import type { IDatabasePort, QueryOptions, QueryResult } from "../../domain/ports/database.port.ts";

export class SupabaseDatabaseAdapter implements IDatabasePort {
  private client: SupabaseClient;

  constructor(url: string, key: string, authHeader?: string) {
    const options: { auth: { autoRefreshToken: boolean; persistSession: boolean }; global?: { headers: { Authorization: string } } } = {
      auth: {
        autoRefreshToken: false,
        persistSession: false,
      },
    };

    if (authHeader) {
      options.global = {
        headers: { Authorization: authHeader },
      };
    }

    this.client = createClient(url, key, options);
  }

  async query<T>(table: string, options?: QueryOptions): Promise<QueryResult<T>> {
    let query = this.client.from(table).select(options?.select ?? "*");

    if (options?.filters) {
      for (const [key, value] of Object.entries(options.filters)) {
        if (value !== undefined && value !== null) {
          if (key.endsWith("_gte")) {
            query = query.gte(key.replace("_gte", ""), value);
          } else if (key.endsWith("_lte")) {
            query = query.lte(key.replace("_lte", ""), value);
          } else {
            query = query.eq(key, value);
          }
        }
      }
    }

    if (options?.order) {
      query = query.order(options.order.column, { ascending: options.order.ascending ?? false });
    }

    if (options?.limit) {
      query = query.limit(options.limit);
    }

    if (options?.offset) {
      query = query.range(options.offset, options.offset + (options.limit ?? 100) - 1);
    }

    const { data, error } = await query;

    return {
      data: data as T[] | null,
      error: error ? new Error(error.message) : null,
    };
  }

  async rpc<T>(functionName: string, params?: Record<string, unknown>): Promise<{ data: T | null; error: Error | null }> {
    const { data, error } = await this.client.rpc(functionName, params);

    return {
      data: data as T | null,
      error: error ? new Error(error.message) : null,
    };
  }

  getClient(): SupabaseClient {
    return this.client;
  }
}
