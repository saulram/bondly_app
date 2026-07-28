/**
 * Auth Port - Domain interface for authentication
 * Following hexagonal architecture, this defines what the domain needs
 * without knowing HOW it's implemented
 */

export interface UserMetadata {
  role: "superAdmin" | "admin" | "client";
  company_name?: string;
  account_number?: number;
  account_type?: "creator" | "invitee";
}

export interface AuthenticatedUser {
  id: string;
  email: string;
  metadata: UserMetadata;
}

export interface IAuthPort {
  /**
   * Validate authorization token and return user if valid
   */
  validateToken(token: string): Promise<AuthenticatedUser | null>;

  /**
   * Check if user has admin role
   */
  isAdmin(user: AuthenticatedUser): boolean;

  /**
   * Check if user is superAdmin
   */
  isSuperAdmin(user: AuthenticatedUser): boolean;
}
