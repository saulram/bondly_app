/// <reference lib="deno.ns" />

/**
 * Edge Function: Generate Badge Report
 * Generates CSV report of badge acknowledgments
 *
 * @method POST
 * @auth Required (admin or superAdmin)
 * @body { badge_id?, category_id?, start_date?, end_date?, account? }
 */

import { badgeReportHandler } from "./presentation/handlers/badge-report.handler.ts";

Deno.serve((req: Request): Promise<Response> => {
  return badgeReportHandler.handle(req);
});
