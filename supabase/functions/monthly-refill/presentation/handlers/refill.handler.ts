/**
 * Monthly Refill HTTP Handler
 * Presentation layer request handling
 */

import { MonthlyRefillUseCase } from "../../application/use-cases/monthly-refill.use-case.ts";
import { RefillRepository } from "../../infrastructure/repositories/refill.repository.ts";
import {
  HttpResponse,
  HttpRequest,
  authMiddleware,
  environment,
} from "../../../_shared/mod.ts";
import { createClient } from "@supabase/supabase-js";

export class RefillHandler {
  async handle(req: Request): Promise<Response> {
    HttpResponse.setOrigin(req);

    // Handle CORS preflight
    if (HttpRequest.isPreflight(req)) {
      return HttpResponse.cors();
    }

    // Only allow POST
    if (!HttpRequest.isMethod(req, "POST")) {
      return HttpResponse.methodNotAllowed();
    }

    try {
      const authHeader = req.headers.get("Authorization");

      // If auth header present, validate it's a superAdmin
      // If no auth header, assume it's a scheduled call (only works with service role)
      if (authHeader) {
        const authResult = await authMiddleware.authenticate(req, "superAdmin");
        if (authResult.error) {
          return authResult.error;
        }
      }

      // Create admin client for RPC call
      const client = createClient(
        environment.supabaseUrl,
        environment.supabaseServiceRoleKey,
        { auth: { autoRefreshToken: false, persistSession: false } }
      );

      // Execute use case
      const repository = new RefillRepository(client);
      const useCase = new MonthlyRefillUseCase(repository);
      const result = await useCase.execute();

      return HttpResponse.json(result);
    } catch (error) {
      console.error("Error in monthly refill:", error);
      const message = error instanceof Error ? error.message : "Error interno";
      return HttpResponse.internalError(message);
    }
  }
}

export const refillHandler = new RefillHandler();
