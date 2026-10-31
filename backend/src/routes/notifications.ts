import { Router } from "express";
import { requireAuth } from "../middleware/auth.js";
import { supabase } from "../config/supabase.js";
import { AppError } from "../utils/http.js";

export const notificationsRouter=Router(); notificationsRouter.use(requireAuth);
async function createDueNotifications(userId:string){
  const today=new Date().toISOString().slice(0,10);
  const{data:plans}=await supabase.from("revision_plans").select("id").eq("user_id",userId).eq("status","active");
  const ids=(plans||[]).map(p=>p.id); if(!ids.length)return;
  const{data:tasks}=await supabase.from("revision_plan_tasks").select("id,activity").in("plan_id",ids).eq("scheduled_date",today).eq("status","pending");
  if(tasks?.length)await supabase.from("notifications").upsert(tasks.map(t=>({user_id:userId,type:"revision_task",title:"Revision task due",message:t.activity,link:"/app/revision-plan",event_key:`revision:${t.id}:${today}`})),{onConflict:"user_id,event_key",ignoreDuplicates:true});
  const soon=new Date(Date.now()+24*60*60*1000).toISOString();
  const{data:exams}=await supabase.from("exams").select("id,title,start_date").eq("status","published").gte("start_date",new Date().toISOString()).lte("start_date",soon);
  if(exams?.length)await supabase.from("notifications").upsert(exams.map(e=>({user_id:userId,type:"upcoming_exam",title:"Upcoming exam",message:`${e.title} opens within 24 hours.`,link:`/app/exams/${e.id}`,event_key:`upcoming:${e.id}:${String(e.start_date).slice(0,10)}`})),{onConflict:"user_id,event_key",ignoreDuplicates:true});
}
notificationsRouter.get("/",async(req,res,next)=>{try{await createDueNotifications(req.authUser!.id);const{data,error,count}=await supabase.from("notifications").select("id,type,title,message,link,is_read,created_at",{count:"exact"}).eq("user_id",req.authUser!.id).order("created_at",{ascending:false}).limit(100);if(error)throw new AppError(500,"Unable to load notifications.");const unread=(data||[]).filter(n=>!n.is_read).length;res.json({notifications:data||[],unread_count:unread,total:count||0})}catch(e){next(e)}});
notificationsRouter.patch("/:id/read",async(req,res,next)=>{try{const{data,error}=await supabase.from("notifications").update({is_read:true}).eq("id",req.params.id).eq("user_id",req.authUser!.id).select("id").maybeSingle();if(error||!data)throw new AppError(404,"Notification not found.");res.json({message:"Notification marked as read."})}catch(e){next(e)}});
notificationsRouter.post("/read-all",async(req,res,next)=>{try{const{error}=await supabase.from("notifications").update({is_read:true}).eq("user_id",req.authUser!.id).eq("is_read",false);if(error)throw new AppError(500,"Unable to mark notifications as read.");res.json({message:"All notifications marked as read."})}catch(e){next(e)}});
