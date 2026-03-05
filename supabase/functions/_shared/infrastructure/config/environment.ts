/**
 * Environment Configuration
 * Centralized environment variable management
 */

export interface EnvironmentConfig {
  supabaseUrl: string;
  supabaseAnonKey: string;
  supabaseServiceRoleKey: string;
}

class Environment {
  private config: EnvironmentConfig | null = null;

  private getEnvOrThrow(key: string): string {
    const value = Deno.env.get(key);
    if (!value) {
      throw new Error(`Missing required environment variable: ${key}`);
    }
    return value;
  }

  getConfig(): EnvironmentConfig {
    if (!this.config) {
      this.config = {
        supabaseUrl: this.getEnvOrThrow("SUPABASE_URL"),
        supabaseAnonKey: this.getEnvOrThrow("SUPABASE_ANON_KEY"),
        supabaseServiceRoleKey: this.getEnvOrThrow("SUPABASE_SERVICE_ROLE_KEY"),
      };
    }
    return this.config;
  }

  get supabaseUrl(): string {
    return this.getConfig().supabaseUrl;
  }

  get supabaseAnonKey(): string {
    return this.getConfig().supabaseAnonKey;
  }

  get supabaseServiceRoleKey(): string {
    return this.getConfig().supabaseServiceRoleKey;
  }
}

export const environment = new Environment();
