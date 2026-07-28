/// <reference lib="deno.ns" />

/**
 * Edge Function: Generate Exchange Report
 * Generates CSV report of reward exchanges/redemptions
 *
 * @method POST
 * @auth Required (admin or superAdmin)
 * @body { status?, start_date?, end_date?, company_name? }
 */

import { exchangeReportHandler } from "./presentation/handlers/exchange-report.handler.ts";

Deno.serve((req: Request): Promise<Response> => {
  return exchangeReportHandler.handle(req);
});
