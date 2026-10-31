import test from "node:test";
import assert from "node:assert/strict";
import { calculateXp, eligibleBadges, levelProgress, nextStreak, notificationEvent, rankExamLeaderboard, rankLeaderboard, xpTransactionKey } from "../utils/gamificationEngine.js";

test("XP is calculated only from authoritative result signals",()=>{assert.equal(calculateXp({correct:8,hardCorrect:2,perfect:false,firstActivityToday:true}).total,140)});
test("duplicate XP rewards resolve to the same ledger key",()=>{assert.equal(xpTransactionKey("u","exam_attempt","a","quiz_completed"),xpTransactionKey("u","exam_attempt","a","quiz_completed"))});
test("level progression reports the next threshold",()=>{const x=levelProgress(350,[{level_number:1,name:"One",xp_required:0},{level_number:2,name:"Two",xp_required:200},{level_number:3,name:"Three",xp_required:500}]);assert.equal(x.current.level_number,2);assert.equal(x.xpToNext,150);assert.equal(x.progress,50)});
test("streak increases once per day and resets after a gap",()=>{assert.deepEqual(nextStreak(4,8,"2026-08-24","2026-08-25"),{current:5,longest:8,increased:true});assert.equal(nextStreak(5,8,"2026-08-25","2026-08-25").increased,false);assert.equal(nextStreak(5,8,"2026-08-20","2026-08-25").current,1)});
test("badges are awarded by criteria",()=>{const out=eligibleBadges([{id:"a",criteria_type:"total_xp",criteria_value:500}],new Set(),{total_xp:600});assert.equal(out[0].id,"a")});
test("already earned badges cannot be awarded twice",()=>{assert.equal(eligibleBadges([{id:"a",criteria_type:"total_xp",criteria_value:1}],new Set(["a"]),{total_xp:10}).length,0)});
test("global ranking uses XP then accuracy then quizzes",()=>{const rows=rankLeaderboard([{user_id:"a",xp:100,accuracy:70,quizzes:3},{user_id:"b",xp:100,accuracy:80,quizzes:1}]);assert.equal(rows[0].user_id,"b")});
test("exam ranking uses score, time, then submission",()=>{const rows=rankExamLeaderboard([{user_id:"a",score:90,time:100,submitted_at:"2026-01-02"},{user_id:"b",score:90,time:90,submitted_at:"2026-01-03"}]);assert.equal(rows[0].user_id,"b")});
test("notification creation has a duplicate-safe event key",()=>{assert.equal(notificationEvent("u","badge_earned","b","Badge","Earned","/app/achievements").event_key,"badge_earned:b")});
