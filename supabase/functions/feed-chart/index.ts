/// <reference lib="deno.ns" />

/**
 * Edge Function: Feed Chart Data
 * Returns aggregated data for feed activity visualization
 *
 * @method GET
 * @auth Required
 * @query { account?, days? }
 */

import { feedChartHandler } from "./presentation/handlers/feed-chart.handler.ts";

Deno.serve((req: Request): Promise<Response> => {
  return feedChartHandler.handle(req);
});
