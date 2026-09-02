export interface GeminiModel {
  name: string;
  supportedGenerationMethods?: string[];
}

const STATIC_FALLBACK_MODELS = [
  "gemini-flash-latest",
  "gemini-3.7-flash",
  "gemini-3.6-flash",
  "gemini-3.5-flash",
  "gemini-3.5-flash-lite",
  "gemini-3.1-flash-lite",
  "gemini-2.5-flash",
] as const;

const SPECIALIZED_MODEL_MARKERS = [
  "-audio",
  "-image",
  "-live",
  "-omni",
  "-robotics",
  "-transcribe",
  "-tts",
] as const;

function modelId(name: string): string {
  return name.replace(/^models\//, "");
}

function isStableFlashModel(id: string): boolean {
  if (!id.startsWith("gemini-") || !id.includes("-flash")) return false;
  if (id.includes("-preview") || id.includes("-exp")) return false;
  return !SPECIALIZED_MODEL_MARKERS.some((marker) => id.includes(marker));
}

function versionParts(id: string): number[] {
  const match = /^gemini-(\d+(?:\.\d+)+)-/.exec(id);
  return match ? match[1].split(".").map(Number) : [];
}

function compareVersionsDescending(left: string, right: string): number {
  const leftParts = versionParts(left);
  const rightParts = versionParts(right);
  const length = Math.max(leftParts.length, rightParts.length);

  for (let index = 0; index < length; index++) {
    const difference = (rightParts[index] ?? 0) - (leftParts[index] ?? 0);
    if (difference !== 0) return difference;
  }

  const leftLite = left.includes("-flash-lite");
  const rightLite = right.includes("-flash-lite");
  if (leftLite !== rightLite) return leftLite ? 1 : -1;

  const leftVersioned = /-\d{3}$/.test(left);
  const rightVersioned = /-\d{3}$/.test(right);
  if (leftVersioned !== rightVersioned) return leftVersioned ? 1 : -1;

  return left.localeCompare(right);
}

export function selectGeminiModels(models: GeminiModel[]): string[] {
  const discovered = models
    .filter((model) =>
      model.supportedGenerationMethods?.includes("generateContent")
    )
    .map((model) => modelId(model.name))
    .filter(isStableFlashModel)
    .sort(compareVersionsDescending);

  return [...new Set([...discovered, ...STATIC_FALLBACK_MODELS])];
}

export function isRetryableModelError(
  status: number,
  message: string,
): boolean {
  if ([404, 408, 429, 500, 502, 503, 504].includes(status)) return true;

  const normalized = message.toLowerCase();
  return normalized.includes("model") && (
    normalized.includes("not found") ||
    normalized.includes("no longer available") ||
    normalized.includes("not supported") ||
    normalized.includes("overloaded")
  );
}
