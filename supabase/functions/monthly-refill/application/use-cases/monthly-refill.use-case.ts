/**
 * Monthly Refill Use Case
 * Application layer business logic
 */

import type { IRefillRepository } from "../../domain/ports/refill.repository.port.ts";
import type { RefillResult } from "../../domain/entities/refill.entity.ts";

export class MonthlyRefillUseCase {
  constructor(private readonly repository: IRefillRepository) {}

  async execute(): Promise<RefillResult> {
    const result = await this.repository.executeMonthlyRefill();
    console.log("Monthly refill completed:", result);
    return result;
  }
}
