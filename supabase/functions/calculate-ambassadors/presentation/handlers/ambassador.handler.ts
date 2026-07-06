/**
 * Ambassador Calculation HTTP Handler
 * Presentation layer request handling
 */

import {
  HttpResponse,
  HttpRequest,
  authMiddleware,
  environment,
} from "../../../_shared/mod.ts";
import { createClient } from "@supabase/supabase-js";

export class AmbassadorHandler {
  async handle(req: Request): Promise<Response> {
    HttpResponse.setOrigin(req);

    if (HttpRequest.isPreflight(req)) {
      return HttpResponse.cors();
    }

    if (!HttpRequest.isMethod(req, "POST")) {
      return HttpResponse.methodNotAllowed();
    }

    try {
      const authHeader = req.headers.get("Authorization");

      // Validate superAdmin when auth header present; allow cron calls without auth
      if (authHeader) {
        const authResult = await authMiddleware.authenticate(req, "superAdmin");
        if (authResult.error) {
          return authResult.error;
        }
      }

      const client = createClient(
        environment.supabaseUrl,
        environment.supabaseServiceRoleKey,
        { auth: { autoRefreshToken: false, persistSession: false } }
      );

      const { data, error } = await client.rpc("calculate_monthly_ambassadors");

      if (error) {
        throw new Error(error.message);
      }

      return HttpResponse.json(data);
    } catch (error) {
      console.error("Error in ambassador calculation:", error);
      const message = error instanceof Error ? error.message : "Error interno";
      return HttpResponse.internalError(message);
    }
  }
}

export const ambassadorHandler = new AmbassadorHandler();
