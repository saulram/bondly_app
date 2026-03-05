/**
 * HTTP Response Utilities
 * Presentation layer response handling
 */

const CORS_HEADERS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

export class HttpResponse {
  /**
   * Handle CORS preflight request
   */
  static cors(): Response {
    return new Response(null, {
      status: 204,
      headers: CORS_HEADERS,
    });
  }

  /**
   * JSON response with CORS headers
   */
  static json<T>(data: T, status = 200): Response {
    return new Response(JSON.stringify(data), {
      status,
      headers: {
        ...CORS_HEADERS,
        "Content-Type": "application/json",
      },
    });
  }

  /**
   * Success response
   */
  static success<T>(data: T, message?: string): Response {
    return this.json({ success: true, data, ...(message && { message }) });
  }

  /**
   * Error response
   */
  static error(message: string, status = 400): Response {
    return this.json({ success: false, message }, status);
  }

  /**
   * Unauthorized response (401)
   */
  static unauthorized(message = "No autorizado"): Response {
    return this.error(message, 401);
  }

  /**
   * Forbidden response (403)
   */
  static forbidden(message = "Acceso denegado"): Response {
    return this.error(message, 403);
  }

  /**
   * Not found response (404)
   */
  static notFound(message = "Recurso no encontrado"): Response {
    return this.error(message, 404);
  }

  /**
   * Method not allowed response (405)
   */
  static methodNotAllowed(message = "Método no permitido"): Response {
    return this.error(message, 405);
  }

  /**
   * Internal server error (500)
   */
  static internalError(message = "Error interno del servidor"): Response {
    return this.error(message, 500);
  }

  /**
   * CSV file download response
   */
  static csv(content: string, filename: string): Response {
    return new Response(content, {
      headers: {
        ...CORS_HEADERS,
        "Content-Type": "text/csv; charset=utf-8",
        "Content-Disposition": `attachment; filename="${filename}"`,
      },
    });
  }
}
