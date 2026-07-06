/**
 * Supabase Auth Adapter - Infrastructure implementation of IAuthPort
 */

import { createClient, SupabaseClient } from "@supabase/supabase-js";
import type { IAuthPort, AuthenticatedUser, UserMetadata } from "../../domain/ports/auth.port.ts";

export class SupabaseAuthAdapter implements IAuthPort {
  private client: SupabaseClient;

  constructor(url: string, serviceRoleKey: string) {
    this.client = createClient(url, serviceRoleKey, {
      auth: {
        autoRefreshToken: false,
        persistSession: false,
      },
    });
  }

  async validateToken(token: string): Promise<AuthenticatedUser | null> {
    const { data: { user }, error } = await this.client.auth.getUser(token);

    if (error || !user) {
      return null;
    }

    const metadata = user.user_metadata as UserMetadata;

    // Role comes from public.users (source of truth) — JWT metadata goes
    // stale when the admin panel changes a user's role.
    const { data: dbUser } = await this.client
      .from("users")
      .select("role")
      .eq("id", user.id)
      .maybeSingle();

    return {
      id: user.id,
      email: user.email ?? "",
      metadata: {
        role: dbUser?.role ?? metadata?.role ?? "client",
        company_name: metadata?.company_name,
        account_number: metadata?.account_number,
        account_type: metadata?.account_type,
      },
    };
  }

  isAdmin(user: AuthenticatedUser): boolean {
    return user.metadata.role === "admin" || user.metadata.role === "superAdmin";
  }

  isSuperAdmin(user: AuthenticatedUser): boolean {
    return user.metadata.role === "superAdmin";
  }
}
