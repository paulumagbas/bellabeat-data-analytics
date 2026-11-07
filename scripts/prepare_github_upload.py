"""Copy the reviewed portfolio files to a fresh upload folder; no publishing."""
from pathlib import Path
import re
import shutil
from urllib.parse import unquote, urlsplit

root = Path(__file__).resolve().parents[1]
destination = root / 'github-upload'
if destination.exists():
    raise SystemExit('github-upload already exists; no files were changed.')

files = [root / 'README.md', root / '.gitignore']
files += [root / name for name in (
    'participant_steps_summary.csv', 'weekday_steps_same_participants.csv',
    'Sleep Analysis Participant-Level Summary.csv',
    'Activity Sleep Analysis Participant Level Matched Days.csv')]
for folder in ('documentation', 'reports', 'sql', 'scripts'):
    files += [p for p in (root / folder).iterdir()
              if p.is_file() and p.suffix in ('.md', '.sql', '.py', '.mjs', '.json', '.csv')]
files += [root / 'visualizations' / name for name in (
    'Bellabeat_Analysis.twbx', 'bellabeat_dashboard.png', 'activity_sleep_diagnostic.png')]

assert all(p.is_file() for p in files)
assert len(files) <= 100
assert all(p.stat().st_size < 25 * 1024**2 for p in files)
destination.mkdir()
for source in sorted(files):
    target = destination / source.relative_to(root)
    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(source, target)

broken = []
for p in destination.rglob('*.md'):
    for raw in re.findall(r'\]\(([^\n]+)\)', p.read_text(encoding='utf-8')):
        target = raw.strip().strip('<>')
        if urlsplit(target).scheme or target.startswith('#'):
            continue
        if not (p.parent / unquote(target.split('#')[0])).exists():
            broken.append((str(p.relative_to(destination)), target))
if broken:
    raise SystemExit(f'Upload copies created but link check failed: {broken}')
print(f'Prepared {len(files)} files; relative Markdown link targets pass.')
print(f'Total bytes: {sum(p.stat().st_size for p in files)}')
print(f'Folder: {destination}')
print('Original files unchanged. Nothing uploaded or published.')
