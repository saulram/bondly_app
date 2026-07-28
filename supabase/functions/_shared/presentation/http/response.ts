/**
 * HTTP Response Utilities
 * Presentation layer response handling
 */

const ALLOWED_ORIGINS = [
  "https://bondly-app.vercel.app",
];

/**
 * Check if an origin is allowed for CORS.
 * Allows: production Vercel URL, Vercel preview deploys, and localhost for dev.
 */
function isAllowedOrigin(origin: string | null): boolean {
  if (!origin) return false;
  if (ALLOWED_ORIGINS.includes(origin)) return true;
  if (/^https:\/\/bondly-app-.+\.vercel\.app$/.test(origin)) return true;
  if (/^http:\/\/localhost(:\d+)?$/.test(origin)) return true;
  return false;
}

export class HttpResponse {
  private static _origin: string | null = null;

  /**
   * Set the request origin for CORS headers.
   * Call at the start of each request handler.
   */
  static setOrigin(req: Request): void {
    this._origin = req.headers.get("origin");
  }

  private static get corsHeaders(): Record<string, string> {
    const origin = isAllowedOrigin(this._origin)
      ? this._origin!
      : ALLOWED_ORIGINS[0];

    return {
      "Access-Control-Allow-Origin": origin,
      "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
      "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
      "Vary": "Origin",
    };
  }

  /**
   * Handle CORS preflight request
   */
  static cors(): Response {
    return new Response(null, {
      status: 204,
      headers: this.corsHeaders,
    });
  }

  /**
   * JSON response with CORS headers
   */
  static json<T>(data: T, status = 200): Response {
    return new Response(JSON.stringify(data), {
      status,
      headers: {
        ...this.corsHeaders,
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
        ...this.corsHeaders,
        "Content-Type": "text/csv; charset=utf-8",
        "Content-Disposition": `attachment; filename="${filename}"`,
      },
    });
  }
}
