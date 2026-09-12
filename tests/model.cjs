const assert=require('node:assert/strict');const M=require('../Resources/model.js');
assert.equal(M.stages.en.length,11);assert.equal(M.stages.ko.length,11);
assert.deepEqual(M.stages.ko,['기획','자료 수집','분석','초록','도표','초고','다듬기','투고','수정','재투고','게재']);
const p={id:'p',name:'Synthetic',priority:1,steps:Array(11).fill(false),last:'2026-09-12',delays:0};
assert.equal(M.score(p),11);assert.deepEqual(M.totals([p,{...p,steps:Array(11).fill(true)}]),{total:11,average:5.5});assert.equal(M.days('2026-10-01','2026-09-30'),1);assert.ok(Number.isNaN(M.ordinal('2026-02-30')));
const s={version:1,language:'ko',projects:[p],todos:[]};assert.ok(M.valid(s));assert.ok(!M.valid({...s,projects:[{...p,steps:Array(10).fill(false)}]}));assert.equal(M.level(M.target(s,'2026-09-12'),'2026-09-12'),0);assert.equal(M.level(M.target(s,'2026-09-15'),'2026-09-15'),1);p.delays=2;assert.equal(M.level(M.target(s,'2026-09-15'),'2026-09-15'),2);p.steps.fill(true);assert.equal(M.target(s),undefined);
require('../Resources/strings.js');assert.deepEqual(Object.keys(DeskStrings.en).sort(),Object.keys(DeskStrings.ko).sort());
console.log('PASS: canonical 11 stages, scores, dates, validation, escalation, completion and locale parity');
