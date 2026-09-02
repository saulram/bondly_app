import { serve } from "https://deno.land/std@0.208.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.47.10";
import {
  type GeminiModel,
  isRetryableModelError,
  selectGeminiModels,
} from "./model_selector.ts";

const GEMINI_API_BASE_URL = "https://generativelanguage.googleapis.com/v1beta";
const MODEL_CACHE_TTL_MS = 15 * 60 * 1000;
const MAX_MODEL_ATTEMPTS = 4;
const MAX_PROMPT_LENGTH = 100_000;

const ALLOWED_ORIGINS = [
  "https://bondly-app.vercel.app",
  "https://bondly.fluss.mx",
];

interface GeminiModelsResponse {
  models?: GeminiModel[];
  nextPageToken?: string;
}

interface GeminiGenerateResponse {
  candidates?: Array<{
    content?: { parts?: Array<{ text?: string }> };
    finishReason?: string;
  }>;
  error?: { code?: number; message?: string; status?: string };
}

let cachedModels: { expiresAt: number; names: string[] } | null = null;

function getCorsHeaders(origin: string | null): Record<string, string> {
  let allowed = ALLOWED_ORIGINS[0];
  if (origin) {
    if (
      ALLOWED_ORIGINS.includes(origin) ||
      /^https:\/\/bondly-app-.+\.vercel\.app$/.test(origin) ||
      /^https:\/\/[a-z0-9-]+\.fluss\.mx$/.test(origin) ||
      /^http:\/\/localhost(:\d+)?$/.test(origin)
    ) {
      allowed = origin;
    }
  }
  return {
    "Access-Control-Allow-Origin": allowed,
    "Access-Control-Allow-Methods": "POST, OPTIONS",
    "Access-Control-Allow-Headers":
      "authorization, x-client-info, apikey, content-type",
    "Vary": "Origin",
  };
}

function jsonResponse(
  body: unknown,
  status: number,
  corsHeaders: Record<string, string>,
): Response {
  return Response.json(body, { status, headers: corsHeaders });
}

async function discoverModels(apiKey: string): Promise<string[]> {
  if (cachedModels && cachedModels.expiresAt > Date.now()) {
    return cachedModels.names;
  }

  const models: GeminiModel[] = [];
  let pageToken: string | undefined;

  try {
    do {
      const url = new URL(`${GEMINI_API_BASE_URL}/models`);
      url.searchParams.set("pageSize", "1000");
      if (pageToken) url.searchParams.set("pageToken", pageToken);

      const response = await fetch(url, {
        headers: { "x-goog-api-key": apiKey },
        signal: AbortSignal.timeout(10_000),
      });
      if (!response.ok) {
        throw new Error(`models.list returned HTTP ${response.status}`);
      }

      const payload = await response.json() as GeminiModelsResponse;
      models.push(...(payload.models ?? []));
      pageToken = payload.nextPageToken;
    } while (pageToken);
  } catch (error) {
    console.warn("Gemini model discovery failed; using safe fallbacks", error);
  }

  const names = selectGeminiModels(models);
  cachedModels = { expiresAt: Date.now() + MODEL_CACHE_TTL_MS, names };
  return names;
}

async function generateWithModel(
  apiKey: string,
  model: string,
  prompt: string,
): Promise<{ finishReason?: string; text: string }> {
  const response = await fetch(
    `${GEMINI_API_BASE_URL}/models/${
      encodeURIComponent(model)
    }:generateContent`,
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "x-goog-api-key": apiKey,
      },
      body: JSON.stringify({
        contents: [{ role: "user", parts: [{ text: prompt }] }],
        generationConfig: {
          maxOutputTokens: 8192,
          responseMimeType: "application/json",
        },
      }),
      signal: AbortSignal.timeout(60_000),
    },
  );

  const payload = await response.json() as GeminiGenerateResponse;
  if (!response.ok) {
    const message = payload.error?.message ??
      `Gemini returned HTTP ${response.status}`;
    const error = new Error(message) as Error & { status?: number };
    error.status = response.status;
    throw error;
  }

  const candidate = payload.candidates?.[0];
  const text = candidate?.content?.parts
    ?.map((part) => part.text ?? "")
    .join("")
    .trim() ?? "";

  if (!text) {
    throw new Error(
      `Empty response from Gemini. Finish reason: ${
        candidate?.finishReason ?? "unknown"
      }`,
    );
  }

  return { finishReason: candidate?.finishReason, text };
}

async function generateContent(
  apiKey: string,
  prompt: string,
): Promise<string> {
  const models = await discoverModels(apiKey);
  const failures: string[] = [];

  for (const model of models.slice(0, MAX_MODEL_ATTEMPTS)) {
    try {
      const result = await generateWithModel(apiKey, model, prompt);
      console.log(
        `Gemini model=${model} responseLength=${result.text.length} finishReason=${
          result.finishReason ?? "unknown"
        }`,
      );
      return result.text;
    } catch (error) {
      const typedError = error as Error & { status?: number };
      const status = typedError.status ?? 500;
      failures.push(`${model}: HTTP ${status}`);

      if (!isRetryableModelError(status, typedError.message)) throw error;
      console.warn(`Gemini model ${model} unavailable; trying fallback`, {
        status,
        message: typedError.message,
      });
    }
  }

  throw new Error(`No Gemini model was available (${failures.join(", ")})`);
}

// Best-effort only: Supabase isolates do not share in-memory state.
const rateLimitMap = new Map<string, { count: number; resetTime: number }>();
const RATE_LIMIT_WINDOW_MS = 60 * 1000;
const MAX_REQUESTS_PER_WINDOW = 10;

serve(async (req: Request) => {
  const corsHeaders = getCorsHeaders(req.headers.get("origin"));

  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  if (req.method !== "POST") {
    return jsonResponse({ error: "Method not allowed" }, 405, corsHeaders);
  }

  try {
    const authHeader = req.headers.get("Authorization");
    if (!authHeader?.startsWith("Bearer ")) {
      return jsonResponse(
        { error: "Missing or invalid Authorization header" },
        401,
        corsHeaders,
      );
    }

    const supabaseClient = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_ANON_KEY") ?? "",
      { global: { headers: { Authorization: authHeader } } },
    );

    const token = authHeader.slice("Bearer ".length);
    const { data: { user }, error: authError } = await supabaseClient.auth
      .getUser(token);
    if (authError || !user) {
      return jsonResponse(
        { error: "Unauthorized or invalid token" },
        401,
        corsHeaders,
      );
    }

    const ip = req.headers.get("x-forwarded-for")?.split(",")[0].trim() ??
      "unknown";
    const now = Date.now();
    const record = rateLimitMap.get(ip);
    if (!record || now > record.resetTime) {
      rateLimitMap.set(ip, {
        count: 1,
        resetTime: now + RATE_LIMIT_WINDOW_MS,
      });
    } else if (record.count >= MAX_REQUESTS_PER_WINDOW) {
      return jsonResponse(
        { error: "Rate limit exceeded. Try again later." },
        429,
        corsHeaders,
      );
    } else {
      record.count++;
    }

    const geminiApiKey = Deno.env.get("GEMINI_API_KEY");
    if (!geminiApiKey) {
      console.error("GEMINI_API_KEY is not configured");
      return jsonResponse(
        { error: "AI service is not configured" },
        503,
        corsHeaders,
      );
    }

    const body = await req.json().catch(() => null) as
      | { prompt?: unknown }
      | null;
    const prompt = typeof body?.prompt === "string" ? body.prompt.trim() : "";
    if (!prompt) {
      return jsonResponse({ error: "No prompt provided" }, 400, corsHeaders);
    }
    if (prompt.length > MAX_PROMPT_LENGTH) {
      return jsonResponse({ error: "Prompt is too long" }, 413, corsHeaders);
    }

    const responseText = await generateContent(geminiApiKey, prompt);
    return new Response(responseText, {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : "Unknown error";
    console.error("Gemini Edge Function failed", { message });
    return jsonResponse(
      { error: "AI service is temporarily unavailable" },
      503,
      corsHeaders,
    );
  }
});
