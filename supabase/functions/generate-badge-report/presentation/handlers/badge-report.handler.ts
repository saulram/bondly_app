/**
 * Badge Report HTTP Handler
 * Presentation layer request handling
 */

import type { BadgeReportFilters } from "../../domain/entities/badge-report.entity.ts";
import { GenerateBadgeReportUseCase } from "../../application/use-cases/generate-badge-report.use-case.ts";
import { BadgeReportRepository } from "../../infrastructure/repositories/badge-report.repository.ts";
import {
  HttpResponse,
  HttpRequest,
  authMiddleware,
  environment,
} from "../../../_shared/mod.ts";
import { createClient } from "@supabase/supabase-js";

export class BadgeReportHandler {
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
      // Authenticate user (admin required)
      const authResult = await authMiddleware.authenticate(req, "admin");
      if (authResult.error) {
        return authResult.error;
      }

      // Parse request body
      const body = await HttpRequest.parseBody<BadgeReportFilters>(req);
      if (!body) {
        return HttpResponse.error("Cuerpo de solicitud inválido");
      }

      // Create admin client for data access
      const client = createClient(
        environment.supabaseUrl,
        environment.supabaseServiceRoleKey,
        { auth: { autoRefreshToken: false, persistSession: false } }
      );

      // Execute use case
      const repository = new BadgeReportRepository(client);
      const useCase = new GenerateBadgeReportUseCase(repository);
      const result = await useCase.execute(body);

      return HttpResponse.csv(result.content, result.filename);
    } catch (error) {
      console.error("Error generating badge report:", error);
      const message = error instanceof Error ? error.message : "Error interno";
      return HttpResponse.internalError(message);
    }
  }
}

export const badgeReportHandler = new BadgeReportHandler();
