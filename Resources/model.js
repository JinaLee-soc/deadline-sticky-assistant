(function(g){
const stages={ko:['기획','자료 수집','분석','초록','도표','초고','다듬기','투고','수정','재투고','게재'],en:['Planning','Data collection','Analysis','Abstract','Figures & tables','First draft','Polishing','Submission','Revision','Resubmission','Publication']};
const today=()=>{const d=new Date();return `${d.getFullYear()}-${String(d.getMonth()+1).padStart(2,'0')}-${String(d.getDate()).padStart(2,'0')}`};
function ordinal(s){if(!/^\d{4}-\d{2}-\d{2}$/.test(s))return NaN;const [y,m,d]=s.split('-').map(Number),v=new Date(Date.UTC(y,m-1,d));return v.toISOString().slice(0,10)===s?v.getTime()/86400000:NaN}
const days=(due,now=today())=>due?ordinal(due)-ordinal(now):Infinity;
const score=p=>p.steps.filter(v=>!v).length;
const totals=ps=>{const total=ps.reduce((n,p)=>n+score(p),0);return {total,average:ps.length?total/ps.length:0}};
function valid(s){return !!s&&s.version===1&&['en','ko'].includes(s.language)&&Array.isArray(s.projects)&&Array.isArray(s.todos)&&s.projects.every(p=>typeof p.id==='string'&&typeof p.name==='string'&&p.steps?.length===11&&p.steps.every(v=>typeof v==='boolean')&&[1,2,3].includes(p.priority)&&Number.isFinite(ordinal(p.last))&&Number.isInteger(p.delays)&&p.delays>=0)&&s.todos.every(t=>typeof t.id==='string'&&typeof t.name==='string'&&typeof t.done==='boolean'&&[1,2,3].includes(t.priority)&&(!t.due||Number.isFinite(ordinal(t.due)))&&Number.isFinite(ordinal(t.last))&&Number.isInteger(t.delays)&&t.delays>=0&&(!t.project||s.projects.some(p=>p.id===t.project)))}
function target(s,now=today()){return [...s.projects.filter(p=>score(p)).map(p=>({item:p,kind:'projects',due:Math.min(Infinity,...s.todos.filter(t=>t.project===p.id&&!t.done).map(t=>days(t.due,now)))})),...s.todos.filter(t=>!t.done).map(item=>({item,kind:'notes',due:days(item.due,now)}))].sort((a,b)=>a.item.priority-b.item.priority||a.due-b.due)[0]}
function level(t,now=today()){if(!t)return 0;const idle=Math.max(0,ordinal(now)-ordinal(t.item.last));return Math.min(2,(t.due<=2?2:t.due<=5?1:0)+(idle>=3?1:0)+(t.item.delays>=2?1:0))}
g.DeskModel={stages,today,ordinal,days,score,totals,valid,target,level};if(typeof module!=='undefined')module.exports=g.DeskModel;
})(globalThis);
