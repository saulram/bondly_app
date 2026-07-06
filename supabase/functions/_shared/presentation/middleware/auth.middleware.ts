/**
 * Auth Middleware
 * Presentation layer authentication handling
 */

import type { AuthenticatedUser } from "../../domain/ports/auth.port.ts";
import { SupabaseAuthAdapter } from "../../infrastructure/adapters/supabase-auth.adapter.ts";
import { environment } from "../../infrastructure/config/environment.ts";
import { HttpResponse } from "../http/response.ts";

export type AuthRequirement = "none" | "authenticated" | "admin" | "superAdmin";

export interface AuthResult {
  user: AuthenticatedUser | null;
  error: Response | null;
}

export class AuthMiddleware {
  private authAdapter: SupabaseAuthAdapter;

  constructor() {
    this.authAdapter = new SupabaseAuthAdapter(
      environment.supabaseUrl,
      environment.supabaseServiceRoleKey
    );
  }

  async authenticate(req: Request, requirement: AuthRequirement = "authenticated"): Promise<AuthResult> {
    if (requirement === "none") {
      return { user: null, error: null };
    }

    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return {
        user: null,
        error: HttpResponse.unauthorized("Token de autenticación requerido"),
      };
    }

    const token = authHeader.replace("Bearer ", "");
    const user = await this.authAdapter.validateToken(token);

    if (!user) {
      return {
        user: null,
        error: HttpResponse.unauthorized("Token inválido o expirado"),
      };
    }

    if (requirement === "admin" && !this.authAdapter.isAdmin(user)) {
      return {
        user: null,
        error: HttpResponse.forbidden("Se requieren permisos de administrador"),
      };
    }

    if (requirement === "superAdmin" && !this.authAdapter.isSuperAdmin(user)) {
      return {
        user: null,
        error: HttpResponse.forbidden("Se requieren permisos de super administrador"),
      };
    }

    return { user, error: null };
  }
}

export const authMiddleware = new AuthMiddleware();
