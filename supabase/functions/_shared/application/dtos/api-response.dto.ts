/**
 * API Response DTOs
 * Standardized response formats
 */

export interface ApiSuccessResponse<T> {
  success: true;
  data: T;
  message?: string;
}

export interface ApiErrorResponse {
  success: false;
  message: string;
  code?: string;
}

export type ApiResponse<T> = ApiSuccessResponse<T> | ApiErrorResponse;

export function createSuccessResponse<T>(data: T, message?: string): ApiSuccessResponse<T> {
  return {
    success: true,
    data,
    ...(message && { message }),
  };
}

export function createErrorResponse(message: string, code?: string): ApiErrorResponse {
  return {
    success: false,
    message,
    ...(code && { code }),
  };
}
