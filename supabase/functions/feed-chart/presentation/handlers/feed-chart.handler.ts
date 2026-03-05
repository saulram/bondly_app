/**
 * Feed Chart HTTP Handler
 * Presentation layer request handling
 */

import type { FeedChartFilters } from "../../domain/entities/feed-chart.entity.ts";
import { GenerateFeedChartUseCase } from "../../application/use-cases/generate-feed-chart.use-case.ts";
import { FeedChartRepository } from "../../infrastructure/repositories/feed-chart.repository.ts";
import {
  HttpResponse,
  HttpRequest,
  authMiddleware,
  environment,
} from "../../../_shared/mod.ts";
import { createClient } from "@supabase/supabase-js";

export class FeedChartHandler {
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
      const filters: FeedChartFilters = {
        account: HttpRequest.getQueryParamAsNumber(req, "account"),
        days: HttpRequest.getQueryParamAsNumber(req, "days", 30),
      };

      // Create client for data access
      const client = createClient(
        environment.supabaseUrl,
        environment.supabaseServiceRoleKey,
        { auth: { autoRefreshToken: false, persistSession: false } }
      );

      // Execute use case
      const repository = new FeedChartRepository(client);
      const useCase = new GenerateFeedChartUseCase(repository);
      const data = await useCase.execute(filters);

      return HttpResponse.success(data);
    } catch (error) {
      console.error("Error generating feed chart:", error);
      const message = error instanceof Error ? error.message : "Error interno";
      return HttpResponse.internalError(message);
    }
  }
}

export const feedChartHandler = new FeedChartHandler();
