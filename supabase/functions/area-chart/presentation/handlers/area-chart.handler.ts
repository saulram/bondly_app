/**
 * Area Chart HTTP Handler
 * Presentation layer request handling
 */

import type { AreaChartFilters } from "../../domain/entities/area-chart.entity.ts";
import { GenerateAreaChartUseCase } from "../../application/use-cases/generate-area-chart.use-case.ts";
import { AreaChartRepository } from "../../infrastructure/repositories/area-chart.repository.ts";
import {
  HttpResponse,
  HttpRequest,
  authMiddleware,
  environment,
} from "../../../_shared/mod.ts";
import { createClient } from "@supabase/supabase-js";

export class AreaChartHandler {
  async handle(req: Request): Promise<Response> {
    // Handle CORS preflight
    if (HttpRequest.isPreflight(req)) {
      return HttpResponse.cors();
    }

    // Only allow GET
    if (!HttpRequest.isMethod(req, "GET")) {
      return HttpResponse.methodNotAllowed();
    }

    try {
      // Authenticate user
      const authResult = await authMiddleware.authenticate(req, "authenticated");
      if (authResult.error) {
        return authResult.error;
      }

      // Parse query parameters
      const filters: AreaChartFilters = {
        months: HttpRequest.getQueryParamAsNumber(req, "months", 12),
        account: HttpRequest.getQueryParamAsNumber(req, "account"),
      };

      // Create client for data access
      const client = createClient(
        environment.supabaseUrl,
        environment.supabaseServiceRoleKey,
        { auth: { autoRefreshToken: false, persistSession: false } }
      );

      // Execute use case
      const repository = new AreaChartRepository(client);
      const useCase = new GenerateAreaChartUseCase(repository);
      const data = await useCase.execute(filters);

      return HttpResponse.success(data);
    } catch (error) {
      console.error("Error generating area chart:", error);
      const message = error instanceof Error ? error.message : "Error interno";
      return HttpResponse.internalError(message);
    }
  }
}

export const areaChartHandler = new AreaChartHandler();
