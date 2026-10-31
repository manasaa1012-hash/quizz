import { useEffect,useState } from "react";
import { Award,Lock,Medal,Sparkles } from "lucide-react";
import { api } from "../lib/api";

export default function AchievementsPage(){
  const[data,setData]=useState<any>(null),[error,setError]=useState("");
  useEffect(()=>{api.get("/gamification/achievements").then(r=>setData(r.data)).catch(e=>setError(e.message))},[]);
  return <><div className="page-header"><div><span className="eyebrow">MILESTONES</span><h1>Achievements</h1><p>Every badge is earned from verified learning activity.</p></div><div className="achievement-total"><Medal/> {data?.summary?.earned||0} / {data?.summary?.total||0} unlocked</div></div>{error&&<div className="alert error">{error}</div>}
  <div className="achievement-grid">{(data?.badges||[]).map((b:any)=><article key={b.id} className={`achievement-card ${b.earned?"unlocked":"locked"}`}><div className="badge-art">{b.image_url?<img src={b.image_url} alt=""/>:b.earned?<Award/>:<Lock/>}</div><div><div className="section-title"><h2>{b.name}</h2>{b.earned&&<span className="status-badge ok"><Sparkles size={14}/>Unlocked</span>}</div><p>{b.description}</p><div className="progress"><span style={{width:`${b.progress}%`}}/></div><small>{b.earned?`Earned ${new Date(b.earned_at).toLocaleDateString()}`:`${Math.round(b.progress)}% complete`}</small></div></article>)}</div>
  {!data?.badges?.length&&<div className="card empty">Badge definitions will appear here.</div>}</>;
}
