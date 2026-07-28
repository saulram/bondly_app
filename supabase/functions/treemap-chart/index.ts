/// <reference lib="deno.ns" />

/**
 * Edge Function: Treemap Chart Data
 * Returns data for treemap visualization of badge distribution
 *
 * @method GET
 * @auth Required
 * @query { start_date?, end_date? }
 */

import { treemapHandler } from "./presentation/handlers/treemap.handler.ts";

Deno.serve((req: Request): Promise<Response> => {
  return treemapHandler.handle(req);
});
