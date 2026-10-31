import type { ReactNode } from "react";
import type { LucideIcon } from "lucide-react";

type StatusTone = "ok" | "danger" | "warn" | "neutral";

export function StatusBadge({ tone = "neutral", icon: Icon, children }: { tone?: StatusTone; icon?: LucideIcon; children: ReactNode }) {
  return <span className={`status-badge ${tone}`}>{Icon && <Icon size={14} />}{children}</span>;
}
