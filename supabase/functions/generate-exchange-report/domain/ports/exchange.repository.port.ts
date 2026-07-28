/**
 * Exchange Repository Port (Interface)
 */

import type { ExchangeRow, ExchangeReportFilters } from "../entities/exchange.entity.ts";

export interface IExchangeRepository {
  findAll(filters: ExchangeReportFilters): Promise<ExchangeRow[]>;
}
