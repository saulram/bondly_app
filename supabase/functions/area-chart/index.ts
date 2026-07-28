/// <reference lib="deno.ns" />

/**
 * Edge Function: Area Chart Data
 * Returns time-series data for area chart visualization
 *
 * @method GET
 * @auth Required
 * @query { months?, account? }
 */

import { areaChartHandler } from "./presentation/handlers/area-chart.handler.ts";

Deno.serve((req: Request): Promise<Response> => {
  return areaChartHandler.handle(req);
});
