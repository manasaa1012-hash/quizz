import type { ReactNode } from "react";
import type { LucideIcon } from "lucide-react";

type PageHeaderProps = {
  eyebrow: string;
  title: string;
  description: ReactNode;
  icon?: LucideIcon;
  action?: ReactNode;
};

export function PageHeader({ eyebrow, title, description, icon: Icon, action }: PageHeaderProps) {
  return (
    <header className="page-header">
      <div>
        <span className="eyebrow">{eyebrow}</span>
        <div className="page-title-row">
          {Icon && <span className="page-title-icon"><Icon size={20} /></span>}
          <h1>{title}</h1>
        </div>
        <p>{description}</p>
      </div>
      {action && <div className="page-header-action">{action}</div>}
    </header>
  );
}
