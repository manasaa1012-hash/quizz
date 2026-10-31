import type { LucideIcon } from "lucide-react";

export function MetricCard({
  title,
  value,
  subtitle,
  icon: Icon,
  accent = "primary"
}: {
  title: string;
  value: string | number;
  subtitle?: string;
  icon: LucideIcon;
  accent?: "primary" | "violet" | "success" | "warning" | "danger";
}) {
  return (
    <div className={`card metric-card ${accent}`}>
      <div className="metric-icon"><Icon size={20} /></div>
      <div>
        <span className="muted">{title}</span>
        <h2>{value}</h2>
        {subtitle && <small>{subtitle}</small>}
      </div>
    </div>
  );
}
