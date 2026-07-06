/**
 * Refill Repository Port (Interface)
 */

import type { RefillResult } from "../entities/refill.entity.ts";

export interface IRefillRepository {
  executeMonthlyRefill(): Promise<RefillResult>;
}
