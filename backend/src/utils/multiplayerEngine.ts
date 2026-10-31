export const MULTIPLAYER_POINTS={correct:1000,maxSpeedBonus:500,participationXp:25,placementXp:[75,40,20]} as const;
export function multiplayerScore(correct:boolean,responseMs:number,limitSeconds:number){
  if(!correct)return 0; const limit=Math.max(1,limitSeconds*1000); const elapsed=Math.max(0,Math.min(limit,responseMs));
  return MULTIPLAYER_POINTS.correct+Math.floor(MULTIPLAYER_POINTS.maxSpeedBonus*(limit-elapsed)/limit);
}
export type MultiplayerRankInput={user_id:string;score:number;correct_count:number;average_response_ms:number;joined_at:string};
export function rankMultiplayer(rows:MultiplayerRankInput[]){return [...rows].sort((a,b)=>b.score-a.score||b.correct_count-a.correct_count||a.average_response_ms-b.average_response_ms||a.joined_at.localeCompare(b.joined_at)).map((x,i)=>({...x,rank:i+1}));}
export function multiplayerXp(rank:number){return MULTIPLAYER_POINTS.participationXp+(MULTIPLAYER_POINTS.placementXp[rank-1]||0);}
export type RoomGate={status:string;phase:string;activePlayers:number;maxPlayers:number};
export function canJoinRoom(room:RoomGate,alreadyMember=false){if(room.status!=="open"||room.phase!=="lobby")return "Room is not open.";if(alreadyMember)return null;if(room.activePlayers>=room.maxPlayers)return "Room is full.";return null;}
export function canStartRoom(room:RoomGate,isHost:boolean,allReady:boolean){if(!isHost)return "Only the host can start.";if(room.status!=="open"||room.phase!=="lobby")return "Room is not open.";if(room.activePlayers<2)return "At least two active players are required.";if(!allReady)return "All players must be ready.";return null;}
export function canAnswerQuestion(status:string,phase:string,isMember:boolean,alreadyAnswered:boolean,nowMs:number,startMs:number,endMs:number){if(!isMember)return "Not an active member.";if(status!=="in_progress"||phase!=="question"||nowMs<startMs||nowMs>=endMs)return "Question is not accepting answers.";if(alreadyAnswered)return "Answer already submitted.";return null;}
export function nextMultiplayerPhase(phase:string,index:number,total:number){if(phase==="countdown")return "question";if(phase==="question")return "reveal";if(phase==="reveal")return index+1>=total?"finished":"question";return phase;}
