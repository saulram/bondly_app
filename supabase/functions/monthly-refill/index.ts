/// <reference lib="deno.ns" />

/**
 * Edge Function: Monthly Points Refill
 * Scheduled function to refill user points at the start of each month
 *
 * @method POST
 * @auth Required (superAdmin only) or scheduled call
 *
 * To set up as a cron job, run this SQL in Supabase:
 *
 * ```sql
 * -- Enable pg_cron extension (if not already enabled)
 * CREATE EXTENSION IF NOT EXISTS pg_cron;
 *
 * -- Schedule monthly refill for 1st of each month at midnight UTC
 * SELECT cron.schedule(
 *   'monthly-points-refill',
 *   '0 0 1 * *',
 *   $$SELECT monthly_points_refill();$$
 * );
 * ```
 */

import { refillHandler } from "./presentation/handlers/refill.handler.ts";

Deno.serve((req: Request): Promise<Response> => {
  return refillHandler.handle(req);
});
