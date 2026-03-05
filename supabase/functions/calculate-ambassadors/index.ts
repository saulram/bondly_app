/// <reference lib="deno.ns" />

/**
 * Edge Function: Calculate Monthly Ambassadors
 * Triggers the monthly ambassador calculation.
 * Can be called manually (admin) or scheduled via pg_cron.
 *
 * @method POST
 * @auth Required (superAdmin only)
 *
 * To schedule monthly via pg_cron, see migration 010_ambassador_calculation.sql
 */

import { ambassadorHandler } from "./presentation/handlers/ambassador.handler.ts";

Deno.serve((req: Request): Promise<Response> => {
  return ambassadorHandler.handle(req);
});
