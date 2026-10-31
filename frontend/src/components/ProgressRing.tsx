import type { CSSProperties } from "react";

export function ProgressRing({ value, label, caption, tone = "primary" }: { value: number; label: string; caption: string; tone?: "primary" | "success" | "warning" }) {
  const progress = Math.max(0, Math.min(100, value));
  const style = { "--progress": `${progress}%` } as CSSProperties;

  return (
    <div className={`progress-ring ${tone}`} style={style} aria-label={`${label}: ${Math.round(progress)}%`}>
      <div className="progress-ring-center">
        <strong>{Math.round(progress)}%</strong>
        <span>{label}</span>
      </div>
      <small>{caption}</small>
    </div>
  );
}
