"""Independent stdlib recalculation from local raw CSVs, plus link/workbook audit.

This does not execute GoogleSQL or drive Tableau. No source CSV is modified.
Run from any directory with Python 3.10+.
"""
import csv
import hashlib
import json
import math
import re
import statistics as st
import xml.etree.ElementTree as ET
import zipfile
import struct
from collections import defaultdict
from datetime import datetime
from pathlib import Path
from urllib.parse import unquote, urlsplit

ROOT = Path(__file__).resolve().parents[1]
checks = []

def check(name, ok, detail=None):
    checks.append({'check': name, 'passed': bool(ok), 'detail': detail})

def read(name):
    with (ROOT / name).open(encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))

def near(a, b):
    return math.isclose(float(a), float(b), rel_tol=1e-10, abs_tol=1e-7)

def group(rows, field):
    g = defaultdict(list)
    for r in rows:
        g[r[field]].append(r)
    return g

activity = read('dailyActivity_merged.csv')
sleep_raw = read('sleepDay_merged.csv')
sleep = list({tuple(r.items()): r for r in sleep_raw}.values())
for r in activity:
    r['id'] = r['Id'].strip()
    r['date'] = datetime.strptime(r['ActivityDate'].strip(), '%m/%d/%Y').date()
    r['steps'] = int(r['TotalSteps'])
for r in sleep:
    r['id'] = r['Id'].strip()
    r['date'] = datetime.strptime(r['SleepDay'].strip(), '%m/%d/%Y %I:%M:%S %p').date()
    r['minutes'] = int(r['TotalMinutesAsleep'])
ag, sg = group(activity, 'id'), group(sleep, 'id')
ak = {(r['id'], r['date']): r for r in activity}
check('source counts', (len(activity), len(ag), len(sleep_raw), len(sleep), len(sg)) == (940,33,413,410,24))
check('activity key uniqueness', len(ak) == 940)
check('sleep key uniqueness', len({(r['id'],r['date']) for r in sleep}) == 410)
check('all sleep keys match activity', all((r['id'],r['date']) in ak for r in sleep))

means = {k: st.mean(r['steps'] for r in v) for k,v in ag.items()}
ordered = sorted(means.values())
# Inclusive linear interpolation: h=(n-1)*p, interpolate adjacent order stats.
def percentile(x,p):
    h=(len(x)-1)*p; lo=math.floor(h); hi=math.ceil(h)
    return x[lo]+(h-lo)*(x[hi]-x[lo])
quartiles = [percentile(ordered,p) for p in (.25,.5,.75)]
check('participant quartiles', all(near(a,b) for a,b in zip(quartiles,[5566.870967741936,7282.966666666666,9519.666666666668])),quartiles)
check('median independent cross-check', near(st.median(ordered),quartiles[1]))
check('quartile independent cross-check', all(near(a,b) for a,b in zip(st.quantiles(ordered,n=4,method='inclusive'),quartiles)))
export=read('participant_steps_summary.csv')
check('step summary export IDs',len(export)==33 and {r['participant_id'] for r in export}==set(ag))
check('step summary export values', all(int(r['recorded_days'])==len(ag[r['participant_id']]) and near(r['participant_mean_steps'],means[r['participant_id']]) for r in export))

pw=defaultdict(list)
for r in activity:
    day=(r['date'].weekday()+1)%7+1
    pw[(r['id'],day)].append(r['steps'])
eligible={k for k in ag if sum((k,d) in pw for d in range(1,8))==7}
weekday=[]
for d in range(1,8):
    vals=[v for (k,day),v in pw.items() if day==d and k in eligible]
    weekday.append({'weekday_number':d,'contributing_participants':len(vals),'recorded_days':sum(map(len,vals)),'participant_equal_mean_steps':st.mean(st.mean(v) for v in vals)})
check('same-participant weekday counts',len(eligible)==32 and sum(r['recorded_days'] for r in weekday)==936 and all(r['contributing_participants']==32 for r in weekday))
wexport=read('weekday_steps_same_participants.csv')
check('weekday export', len(wexport)==7 and all(all(near(r[k],weekday[int(r['weekday_number'])-1][k]) for k in weekday[0]) for r in wexport))

sexport=read('Sleep Analysis Participant-Level Summary.csv')
check('sleep export',len(sexport)==24 and all(int(r['recorded_sleep_days'])==len(sg[r['participant_id']]) and near(r['mean_asleep_minutes'],st.mean(v['minutes'] for v in sg[r['participant_id']])) and near(r['mean_asleep_hours'],st.mean(v['minutes'] for v in sg[r['participant_id']])/60) for r in sexport))
sleep_means=sorted(st.mean(r['minutes'] for r in v) for v in sg.values())
check('sleep quartiles',all(near(a,b) for a,b in zip([percentile(sleep_means,p) for p in (.25,.5,.75)],[336.28125,417.2407407407407,449.28125])))
matched={k:{'n':len(v),'steps':st.mean(ak[(r['id'],r['date'])]['steps'] for r in v),'sleep':st.mean(r['minutes'] for r in v)} for k,v in sg.items()}
mexport=read('Activity Sleep Analysis Participant Level Matched Days.csv')
check('matched export',len(mexport)==24 and all(int(r['matched_days'])==matched[r['participant_id']]['n'] and near(r['mean_steps_on_matched_days'],matched[r['participant_id']]['steps']) and near(r['mean_asleep_minutes_on_matched_days'],matched[r['participant_id']]['sleep']) for r in mexport))
corr=[]
for t,expected in [(1,-.0663323518056091),(7,-.3148490504130188),(14,-.42681764288372254)]:
    v=[v for v in matched.values() if v['n']>=t]
    value=st.correlation([r['steps'] for r in v],[r['sleep'] for r in v])
    corr.append({'threshold':t,'participants':len(v),'days':sum(r['n'] for r in v),'r':value})
    check(f'correlation threshold {t}',near(value,expected),value)

package=zipfile.ZipFile(ROOT/'visualizations/Bellabeat_Analysis.twbx')
tree=ET.fromstring(package.read(next(n for n in package.namelist() if n.endswith('.twb'))))
actions=[]
for a in tree.findall('./actions/action'):
    actions.append({'caption':a.get('caption'),'activation':a.find('activation').attrib,'source':a.find('source').attrib,'parameters':{p.get('name'):p.get('value') for p in a.findall('./command/param')}})
connections=[]
for c in tree.findall('.//connection'):
    if c.get('class')=='textscan':
        p=(Path(c.get('directory',''))/c.get('filename','')).as_posix()
        connections.append({'filename':c.get('filename'),'embedded':p in package.namelist(),'package_path':p})
check('Tableau CSV dependencies embedded',all(c['embedded'] for c in connections))
check('only scoped Select highlight action',len(actions)==1 and actions[0]['activation'].get('type')=='on-select' and actions[0]['activation'].get('auto-clear')=='true' and actions[0]['source'].get('worksheet')=='Activity and Sleep' and actions[0]['source'].get('dashboard')=='Activity and Recording Patterns' and set(actions[0]['parameters'].get('exclude','').split(','))=={'Sleep Recording Coverage','Average recorded daily steps vary across participants','Weekday Activity'})
tooltip=' '.join(tree.find("./worksheets/worksheet[@name='Activity and Sleep']/.//customized-tooltip").itertext())
check('tooltip matches click interaction','Click a participant' in tooltip and 'Click empty chart space' in tooltip and 'Hover over a participant' not in tooltip)
png=(ROOT/'visualizations/bellabeat_dashboard.png').read_bytes()
check('full-size dashboard PNG',png[:8]==b'\x89PNG\r\n\x1a\n' and struct.unpack('>II',png[16:24])==(1400,1200))
broken=[]
for p in [ROOT/'README.md',*sorted((ROOT/'documentation').glob('*.md')),*sorted((ROOT/'reports').glob('*.md'))]:
    if not p.exists(): continue
    txt=p.read_text(encoding='utf-8')
    for raw in re.findall(r'\]\(([^\n]+)\)',txt):
        target=raw.strip().strip('<>')
        if urlsplit(target).scheme or target.startswith('#'): continue
        target=unquote(target.split('#')[0])
        if not (p.parent/target).exists():broken.append({'file':str(p.relative_to(ROOT)),'target':target})
check('relative Markdown link targets',not broken,broken)
check('source count discrepancy documented', all(('33' in (ROOT/p).read_text(encoding='utf-8') and 'thirty' in (ROOT/p).read_text(encoding='utf-8').lower()) for p in ['documentation/data_sources_and_roccc.md','reports/final_case_study.md']))
result={'checks':checks,'participant_step_quartiles':quartiles,'quartile_method':'inclusive linear interpolation; no approximate quantile algorithm','step_iqr':quartiles[2]-quartiles[0],'weekday_same_participants':weekday,'correlations':corr,'saved_workbook_actions':actions,'saved_workbook_connections':connections,'source_sha256':{n:hashlib.sha256((ROOT/n).read_bytes()).hexdigest() for n in ['dailyActivity_merged.csv','sleepDay_merged.csv']},'limits':['Local independent calculations, not a fresh BigQuery SQL execution.','XML inspection does not prove runtime highlighting or native export behaviour.','External HTTP links were not tested by the relative-link checker.']}
(ROOT/'reports/qa_results.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
for c in checks: print(('PASS' if c['passed'] else 'FAIL')+': '+c['check'])
print('Saved reports/qa_results.json')
if not all(c['passed'] for c in checks): raise SystemExit(1)
