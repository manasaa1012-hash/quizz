declare global {
  namespace Express {
    interface Request {
      authUser?: { id: string; email?: string; emailConfirmedAt?: string; lastSignInAt?: string };
      profile?: {
        id: string;
        full_name: string;
        email?: string | null;
        institution?: string | null;
        college?: string | null;
        avatar_url?: string | null;
        role: "student" | "admin";
        created_at?: string;
        last_login?: string | null;
        account_status?: "active" | "pending_verification" | "suspended";
      };
    }
  }
}
export {};
