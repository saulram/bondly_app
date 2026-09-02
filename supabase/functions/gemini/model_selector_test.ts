import { assertEquals, assertFalse } from "jsr:@std/assert@1";
import { isRetryableModelError, selectGeminiModels } from "./model_selector.ts";

Deno.test("selectGeminiModels prefers the newest stable general-purpose Flash model", () => {
  const models = selectGeminiModels([
    {
      name: "models/gemini-3.5-flash-lite",
      supportedGenerationMethods: ["generateContent"],
    },
    {
      name: "models/gemini-3.7-flash",
      supportedGenerationMethods: ["generateContent"],
    },
    {
      name: "models/gemini-3.6-flash",
      supportedGenerationMethods: ["generateContent"],
    },
  ]);

  assertEquals(models.slice(0, 3), [
    "gemini-3.7-flash",
    "gemini-3.6-flash",
    "gemini-3.5-flash-lite",
  ]);
});

Deno.test("selectGeminiModels excludes preview and specialized models", () => {
  const models = selectGeminiModels([
    {
      name: "models/gemini-9.0-flash-preview",
      supportedGenerationMethods: ["generateContent"],
    },
    {
      name: "models/gemini-9.0-flash-image",
      supportedGenerationMethods: ["generateContent"],
    },
    {
      name: "models/gemini-9.0-flash",
      supportedGenerationMethods: ["embedContent"],
    },
  ]);

  assertFalse(models.includes("gemini-9.0-flash-preview"));
  assertFalse(models.includes("gemini-9.0-flash-image"));
  assertFalse(models.includes("gemini-9.0-flash"));
  assertEquals(models[0], "gemini-flash-latest");
});

Deno.test("availability and transient failures allow a model fallback", () => {
  assertEquals(isRetryableModelError(404, "model was not found"), true);
  assertEquals(isRetryableModelError(429, "quota exceeded"), true);
  assertEquals(isRetryableModelError(503, "overloaded"), true);
  assertEquals(isRetryableModelError(400, "invalid prompt"), false);
});
