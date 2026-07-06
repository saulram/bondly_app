/**
 * Shared Module Exports
 * Central export point for all shared functionality
 */

// Domain - Ports
export type { IAuthPort, AuthenticatedUser, UserMetadata } from "./domain/ports/auth.port.ts";
export type { IDatabasePort, QueryOptions, QueryResult } from "./domain/ports/database.port.ts";

// Domain - Entities
export type { BadgeReportEntity, BadgeReportFilters } from "./domain/entities/badge-report.entity.ts";
export type { ExchangeEntity, ExchangeFilters, ExchangeStatus } from "./domain/entities/exchange.entity.ts";
export type {
  TreemapNode,
  TimeSeriesDataPoint,
  FeedChartSummary,
  FeedChartDaily,
  FeedChartData,
  FeedType,
} from "./domain/entities/chart-data.entity.ts";
export { FEED_TYPE_LABELS } from "./domain/entities/chart-data.entity.ts";

// Infrastructure - Adapters
export { SupabaseAuthAdapter } from "./infrastructure/adapters/supabase-auth.adapter.ts";
export { SupabaseDatabaseAdapter } from "./infrastructure/adapters/supabase-database.adapter.ts";

// Infrastructure - Config
export { environment, type EnvironmentConfig } from "./infrastructure/config/environment.ts";

// Application - DTOs
export type { ApiResponse, ApiSuccessResponse, ApiErrorResponse } from "./application/dtos/api-response.dto.ts";
export { createSuccessResponse, createErrorResponse } from "./application/dtos/api-response.dto.ts";

// Application - Services
export { CsvGeneratorService, csvGeneratorService, type CsvColumn } from "./application/services/csv-generator.service.ts";

// Presentation - Middleware
export { AuthMiddleware, authMiddleware, type AuthRequirement, type AuthResult } from "./presentation/middleware/auth.middleware.ts";

// Presentation - HTTP
export { HttpResponse } from "./presentation/http/response.ts";
export { HttpRequest } from "./presentation/http/request.ts";
