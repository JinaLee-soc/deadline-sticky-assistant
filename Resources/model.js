(function(g){
const stages={ko:['기획','자료 수집','분석','초록','도표','초고','다듬기','투고','수정','재투고','게재'],en:['Planning','Data collection','Analysis','Abstract','Figures & tables','First draft','Polishing','Submission','Revision','Resubmission','Publication']};
const today=()=>{const d=new Date();return `${d.getFullYear()}-${String(d.getMonth()+1).padStart(2,'0')}-${String(d.getDate()).padStart(2,'0')}`};
function ordinal(s){if(!/^\d{4}-\d{2}-\d{2}$/.test(s))return NaN;const [y,m,d]=s.split('-').map(Number),v=new Date(Date.UTC(y,m-1,d));return v.toISOString().slice(0,10)===s?v.getTime()/86400000:NaN}
const days=(due,now=today())=>due?ordinal(due)-ordinal(now):Infinity;
const applicable=(p,i)=>!(p.excluded||[])[i];
const stageName=(p,i,language='en')=>(p.stageNames||[])[i]||stages[language][i];
const nextStage=p=>p.steps.findIndex((v,i)=>!v&&applicable(p,i));
const score=p=>p.steps.filter((v,i)=>!v&&applicable(p,i)).length;
const totals=ps=>{const total=ps.reduce((n,p)=>n+score(p),0);return {total,average:ps.length?total/ps.length:0}};
function valid(s){
 const item=x=>x&&typeof x.id==='string'&&x.id.length>0&&typeof x.name==='string'&&x.name.length<=100&&[1,2,3].includes(x.priority)&&Number.isFinite(ordinal(x.last))&&Number.isInteger(x.delays)&&x.delays>=0;
 const array=(x,n,test)=>Array.isArray(x)&&x.length===n&&x.every(test);
 if(!s||![1,2].includes(s.version)||!['en','ko'].includes(s.language)||!Array.isArray(s.projects)||!Array.isArray(s.todos))return false;
 if(!s.projects.every(p=>item(p)&&array(p.steps,11,v=>typeof v==='boolean')&&(p.stageNames===undefined||array(p.stageNames,11,v=>typeof v==='string'&&v.length<=60))&&(p.excluded===undefined||array(p.excluded,11,v=>typeof v==='boolean'))))return false;
 if(!s.todos.every(t=>item(t)&&typeof t.done==='boolean'&&(!t.due||Number.isFinite(ordinal(t.due)))&&(!t.project||s.projects.some(p=>p.id===t.project))))return false;
 if(new Set([...s.projects,...s.todos].map(x=>x.id)).size!==s.projects.length+s.todos.length)return false;
 return s.chat===undefined||(Array.isArray(s.chat)&&s.chat.length<=100&&s.chat.every(m=>m&&['user','assistant'].includes(m.role)&&typeof m.text==='string'&&m.text.length<=20000));
}
function candidates(s,now=today()){return [...s.projects.filter(p=>score(p)).map(p=>({item:p,kind:'projects',due:Math.min(Infinity,...s.todos.filter(t=>t.project===p.id&&!t.done).map(t=>days(t.due,now)))})),...s.todos.filter(t=>!t.done).map(item=>({item,kind:'notes',due:days(item.due,now)}))].sort((a,b)=>a.item.priority-b.item.priority||a.due-b.due)}
const target=(s,now=today())=>candidates(s,now)[0];
function level(t,now=today()){if(!t)return 0;const idle=Math.max(0,ordinal(now)-ordinal(t.item.last));return Math.min(2,(t.due<=2?2:t.due<=5?1:0)+Math.floor(idle/3)+(t.item.delays>=2?1:0))}
function reminderLine(lines,intensity,now=today()){const choices=lines[intensity];return choices[ordinal(now)%choices.length]}
function compact(s,now=today()){
 const picks=candidates(s,now).filter(c=>c.kind!=='projects'||!s.todos.some(t=>t.project===c.item.id&&!t.done)).slice(0,3);
 const deadlines=s.todos.filter(t=>!t.done&&t.due&&days(t.due,now)<=30).sort((a,b)=>days(a.due,now)-days(b.due,now));
 return {picks,deadlines};
}
function context(s,now=today()) {return {today:now,language:s.language,projects:s.projects.map(p=>({name:p.name,priority:p.priority,lastRecordedProgress:p.last,postponements:p.delays,remaining:score(p),stages:p.steps.map((done,i)=>({name:stageName(p,i,s.language),status:!applicable(p,i)?'notApplicable':done?'done':'unfinished'}))})),tasks:s.todos.map(t=>({name:t.name,priority:t.priority,due:t.due||null,done:t.done,project:s.projects.find(p=>p.id===t.project)?.name||null})),scoreMeaning:'Number of applicable unfinished stages, not hours or quality'};}
g.DeskModel={applicable,stageName,nextStage,candidates,compact,context,reminderLine,stages,today,ordinal,days,score,totals,valid,target,level};if(typeof module!=='undefined')module.exports=g.DeskModel;
})(globalThis);
