/**
 * HTTP Request Utilities
 * Presentation layer request handling
 */

export class HttpRequest {
  /**
   * Parse JSON body from request
   */
  static async parseBody<T>(req: Request): Promise<T | null> {
    try {
      return await req.json() as T;
    } catch {
      return null;
    }
  }

  /**
   * Get query parameters from URL
   */
  static getQueryParams(req: Request): URLSearchParams {
    return new URL(req.url).searchParams;
  }

  /**
   * Get a specific query parameter
   */
  static getQueryParam(req: Request, key: string): string | null {
    return this.getQueryParams(req).get(key);
  }

  /**
   * Get query parameter as number
   */
  static getQueryParamAsNumber(req: Request, key: string, defaultValue?: number): number | undefined {
    const value = this.getQueryParam(req, key);
    if (value === null) return defaultValue;
    const parsed = parseInt(value, 10);
    return isNaN(parsed) ? defaultValue : parsed;
  }

  /**
   * Check if request method matches
   */
  static isMethod(req: Request, method: string): boolean {
    return req.method.toUpperCase() === method.toUpperCase();
  }

  /**
   * Check if request is CORS preflight
   */
  static isPreflight(req: Request): boolean {
    return req.method === "OPTIONS";
  }
}
