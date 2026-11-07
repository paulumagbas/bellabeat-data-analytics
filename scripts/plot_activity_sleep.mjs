// Read-only source CSV; produces a diagnostic PNG with shared axes.
import fs from 'node:fs/promises';
import { createRequire } from 'node:module';
const require = createRequire(import.meta.url);
const sharp = require('sharp');
const source = process.argv[2];
if (!source) throw new Error('Pass the participant-level matched CSV path.');
const lines = (await fs.readFile(source, 'utf8')).trim().split(/\r?\n/);
const keys = lines.shift().split(',');
const rows = lines.map(l => Object.fromEntries(l.split(',').map((v,i)=>[keys[i],v])));
const xkey='mean_steps_on_matched_days', ykey='mean_asleep_minutes_on_matched_days';
const corr=a=>{const x=a.map(v=>+v[xkey]),y=a.map(v=>+v[ykey]);const mx=x.reduce((a,b)=>a+b)/x.length,my=y.reduce((a,b)=>a+b)/y.length;return x.reduce((s,v,i)=>s+(v-mx)*(y[i]-my),0)/Math.sqrt(x.reduce((s,v)=>s+(v-mx)**2,0)*y.reduce((s,v)=>s+(v-my)**2,0));};
const out=[];
let svg='<svg xmlns="http://www.w3.org/2000/svg" width="1500" height="620"><rect width="1500" height="620" fill="#fafbf9"/><g font-family="Arial, sans-serif" fill="#24343b">';
svg+='<text x="50" y="42" font-size="26" font-weight="bold">Activity and sleep: participant averages on matched dates</text><text x="50" y="72" font-size="16">One point per participant. Identical axes in each panel; all recorded zero-step days retained.</text>';
for (const [j,t] of [1,7,14].entries()) {
 const a=rows.filter(v=>+v.matched_days>=t),r=corr(a),left=75+j*490,top=155,w=390,h=330;
 const X=x=>left+x/20000*w,Y=y=>top+h-y/720*h;
 svg+=`<text x="${left}" y="110" font-size="19" font-weight="bold">At least ${t} matched day${t===1?'':'s'}</text><text x="${left}" y="136" font-size="16">n = ${a.length} participants | Pearson r = ${r.toFixed(3)}</text>`;
 for (const v of [0,5000,10000,15000,20000]) svg+=`<line x1="${X(v)}" x2="${X(v)}" y1="${top}" y2="${top+h}" stroke="#e0e5e5"/><text x="${X(v)}" y="${top+h+26}" text-anchor="middle" font-size="13">${v/1000}k</text>`;
 for (const v of [0,120,240,360,480,600,720]) svg+=`<line x1="${left}" x2="${left+w}" y1="${Y(v)}" y2="${Y(v)}" stroke="#e0e5e5"/><text x="${left-10}" y="${Y(v)+5}" text-anchor="end" font-size="13">${v}</text>`;
 for(const v of a){const c=+v.matched_days<7?'#d88632':+v.matched_days<14?'#527ca5':'#22796e';svg+=`<circle cx="${X(+v[xkey])}" cy="${Y(+v[ykey])}" r="6" fill="${c}" fill-opacity="0.85" stroke="white"/>`;}
 svg+=`<text x="${left+w/2}" y="${top+h+54}" text-anchor="middle" font-size="15">Mean recorded steps</text>`;
 const loo=a.map((v,i)=>({minimum_matched_days:t,omitted_participant:v.participant_id,omitted_matched_days:+v.matched_days,baseline_r:r,r_without_participant:corr(a.filter((_,k)=>k!==i))}));out.push(...loo);
}
svg+='<text x="22" y="320" transform="rotate(-90 22 320)" text-anchor="middle" font-size="15">Mean recorded sleep (minutes)</text>';
for(const [i,label] of ['1-6 matched days','7-13 matched days','14+ matched days'].entries()){const x=75+i*240;svg+=`<circle cx="${x}" cy="570" r="6" fill="${['#d88632','#527ca5','#22796e'][i]}"/><text x="${x+15}" y="575" font-size="15">${label}</text>`;}
svg+='<text x="75" y="606" font-size="14">Source: learner BigQuery export, April 12-May 12, 2016. Same-date association; timing and causation are unresolved.</text></g></svg>';
await fs.mkdir('visualizations',{recursive:true});await fs.mkdir('reports',{recursive:true});
await sharp(Buffer.from(svg)).png().toFile('visualizations/activity_sleep_diagnostic.png');
const cols=Object.keys(out[0]);await fs.writeFile('reports/activity_sleep_leave_one_out.csv',[cols.join(','),...out.map(v=>cols.map(k=>v[k]).join(','))].join('\n'));
for(const t of [1,7,14]){const a=out.filter(v=>v.minimum_matched_days===t);console.log(JSON.stringify({threshold:t,minimum_r:Math.min(...a.map(v=>v.r_without_participant)),maximum_r:Math.max(...a.map(v=>v.r_without_participant))}));}
