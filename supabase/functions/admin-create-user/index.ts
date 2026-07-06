/// <reference lib="deno.ns" />

/**
 * Edge Function: Admin Create User
 * Creates a new user via GoTrue's admin API. The on_auth_user_created
 * trigger (migration 006) creates the public.users / user_profiles /
 * user_points / carts rows from the metadata.
 *
 * @method POST
 * @auth Required (admin or superAdmin; only superAdmin may create superAdmins)
 * @body { email: string, complete_name: string, role?: 'client'|'admin'|'superAdmin', monthly_points?: number }
 *
 * The user is created with a random password + confirmed email; they set
 * their own password through the app's "forgot password" flow.
 */

import { createClient } from "@supabase/supabase-js";
import { authMiddleware, environment, HttpResponse } from "../_shared/mod.ts";

const VALID_ROLES = ["client", "admin", "superAdmin"];

// Module scope: reused across warm invocations
const admin = createClient(
  environment.supabaseUrl,
  environment.supabaseServiceRoleKey,
  { auth: { autoRefreshToken: false, persistSession: false } },
);

Deno.serve(async (req: Request): Promise<Response> => {
  HttpResponse.setOrigin(req);

  if (req.method === "OPTIONS") return HttpResponse.cors();
  if (req.method !== "POST") return HttpResponse.error("Método no permitido", 405);

  const { user, error } = await authMiddleware.authenticate(req, "admin");
  if (error) return error;

  let body: { email?: string; complete_name?: string; role?: string; monthly_points?: number };
  try {
    body = await req.json();
  } catch {
    return HttpResponse.error("Cuerpo de la petición inválido");
  }

  const email = body.email?.trim().toLowerCase();
  const completeName = body.complete_name?.trim();
  const role = body.role ?? "client";
  const monthlyPoints = Number(body.monthly_points ?? 0);

  if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    return HttpResponse.error("Email inválido");
  }
  if (!completeName) return HttpResponse.error("El nombre es requerido");
  if (!VALID_ROLES.includes(role)) return HttpResponse.error("Rol inválido");
  if (!Number.isFinite(monthlyPoints) || monthlyPoints < 0) {
    return HttpResponse.error("Puntos mensuales inválidos");
  }
  if (role === "superAdmin" && user!.metadata.role !== "superAdmin") {
    return HttpResponse.error("Solo un superAdmin puede crear superAdmins", 403);
  }

  const { data, error: createError } = await admin.auth.admin.createUser({
    email,
    email_confirm: true,
    password: crypto.randomUUID(),
    user_metadata: {
      complete_name: completeName,
      role,
      monthly_points: monthlyPoints,
    },
  });

  if (createError) {
    const status = createError.message.includes("already") ? 409 : 400;
    return HttpResponse.error(createError.message, status);
  }

  return HttpResponse.success({ user_id: data.user.id });
});
