/**
 * Treemap Chart HTTP Handler
 * Presentation layer request handling
 */

import type { TreemapFilters } from "../../domain/entities/treemap.entity.ts";
import { GenerateTreemapUseCase } from "../../application/use-cases/generate-treemap.use-case.ts";
import { TreemapRepository } from "../../infrastructure/repositories/treemap.repository.ts";
import {
  HttpResponse,
  HttpRequest,
  authMiddleware,
  environment,
} from "../../../_shared/mod.ts";
import { createClient } from "@supabase/supabase-js";

export class TreemapHandler {
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
      const filters: TreemapFilters = {
        start_date: HttpRequest.getQueryParam(req, "start_date") ?? undefined,
        end_date: HttpRequest.getQueryParam(req, "end_date") ?? undefined,
      };

      // Create client for data access
      const client = createClient(
        environment.supabaseUrl,
        environment.supabaseServiceRoleKey,
        { auth: { autoRefreshToken: false, persistSession: false } }
      );

      // Execute use case
      const repository = new TreemapRepository(client);
      const useCase = new GenerateTreemapUseCase(repository);
      const data = await useCase.execute(filters);

      return HttpResponse.success(data);
    } catch (error) {
      console.error("Error generating treemap:", error);
      const message = error instanceof Error ? error.message : "Error interno";
      return HttpResponse.internalError(message);
    }
  }
}

export const treemapHandler = new TreemapHandler();
