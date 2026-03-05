/**
 * Database Port - Domain interface for database operations
 * Abstracts the database implementation from the domain
 */

export interface QueryOptions {
  select?: string;
  filters?: Record<string, unknown>;
  order?: { column: string; ascending?: boolean };
  limit?: number;
  offset?: number;
}

export interface QueryResult<T> {
  data: T[] | null;
  error: Error | null;
  count?: number;
}

export interface IDatabasePort {
  /**
   * Query records from a table
   */
  query<T>(table: string, options?: QueryOptions): Promise<QueryResult<T>>;

  /**
   * Call a database function (RPC)
   */
  rpc<T>(functionName: string, params?: Record<string, unknown>): Promise<{ data: T | null; error: Error | null }>;
}
