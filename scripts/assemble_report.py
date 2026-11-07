"""Assemble reviewed prose into a review draft; no analytical calculations."""
from pathlib import Path

root = Path(__file__).resolve().parents[1]
reports = root / 'reports'

def section(name):
    text = (reports / name).read_text(encoding='utf-8').strip()
    return '\n'.join('#' + line if line.startswith('#') else line
                     for line in text.splitlines())

intro = '''# Bellabeat Leaf: Activity Patterns and Recording Limitations

Status: reviewed portfolio case study; local Tableau checks completed as recorded
in [publication QA](../documentation/publication_qa.md). Analysis was executed
by the learner in Google BigQuery; reported outputs were independently recalculated
from local CSVs. No proposed marketing test has been executed.

## Business task and audience

Analyze recorded activity, sleep and recording patterns in the supplied Fitbit
data to develop three marketing hypotheses for Bellabeat Leaf. The intended
case-study audience is the marketing analytics team and executive stakeholders,
including cofounders Urška Sršen and Sando Mur, as described in the brief.
Leaf's activity/sleep features in that historical brief align with the selected
measurements; current product claims have not been independently verified.

## Data sources and scope

The specified acquisition source is Mobius's [FitBit Fitness Tracker Data on
Kaggle](https://www.kaggle.com/datasets/arashnic/fitbit). The identified original
research deposit is Furberg, Brinton, Keating and Ortiz (2016),
[Crowd-sourced Fitbit datasets](https://doi.org/10.5281/zenodo.53894).
Source documentation describes Mechanical Turk recruitment; representativeness
and end-to-end file identity are not independently established. Source-described
thirty users differs from the 33 distinct IDs observed in the selected activity
file; that discrepancy remains unresolved.

Only dailyActivity_merged.csv and sleepDay_merged.csv from April 12-May 12, 2016
were analyzed. The archive's earlier period was outside the selected scope.
The source brief describes CC0 licensing; current dataset-specific license
metadata was not independently retrieved during the provenance review.
See [source and ROCCC documentation](../documentation/data_sources_and_roccc.md).
'''

rec = '''### 1. Test messaging about movement across the week

The weekday difference motivates a hypothesis that movement-across-the-week
messaging may resonate with prospects. Randomly compare it with general wellness
messaging while holding audience rules, offer and placement comparable. Predefine
purchase conversion per assigned eligible user as the primary outcome when
reliably measurable, with click-through secondary. This tests messaging; daily
step patterns do not establish optimal advertising days or individual inconsistency.

### 2. Research goals and test preference-based messages

The wide range of participant step averages motivates customer research into
activity interests. Survey/interview Bellabeat prospects about self-reported
goals, then randomly compare preference-matched and general messages within
those groups. Use predefined conversion outcomes, with engagement secondary.
Survey response rate measures research reach, not marketing success. Step counts
do not reveal motivations, and no personalized product capability is assumed.

### 3. Investigate recording barriers and test feature education

Uneven Fitbit sleep recording motivates Bellabeat-specific research, not a
diagnosis of Bellabeat onboarding problems. Interview users about barriers and,
if supported, test instructional onboarding against existing onboarding. Use
comprehension or task success as a primary measure; tutorial completion, reported
usability and appropriately defined subsequent recording frequency can support
it. More records alone do not demonstrate better measurement or sleep quality.

These proposals seek business value through measured learning. None has been
executed and no campaign uplift, product adoption or revenue improvement is
claimed. Detailed evidence-to-test mappings appear in the
[recommendation working paper](marketing_recommendations_draft.md).
'''

end = '''## Visual communication

The learner built a Tableau dashboard with participant activity, weekday activity,
sleep recording coverage and matched activity-sleep scatterplots. Counts, values,
units and median reference values were checked against SQL. Saved-workbook
inspection confirms exactly one scoped Select highlight action. The learner
validated group emphasis, reset and no effect on the other charts, then reopened
a copied package successfully. Different chart populations are labelled in
subtitles. The [packaged workbook](../visualizations/Bellabeat_Analysis.twbx)
contains its CSV dependencies. The [native dashboard export](../visualizations/bellabeat_dashboard.png)
was visually reviewed in full. Hover is not the intended interaction.
No public dashboard URL is claimed.

## Limitations and next steps

The small 2016 sample is not verified Bellabeat customer data and cannot establish
current customer behaviour or women-specific patterns. Recruitment, uneven
recording, absent demographic/goal information and uncertain measurement
completeness limit generalization. Equal participant weighting does not correct
missingness or unequal precision. Daily sleep totals may include multiple sessions;
neither low averages nor variability establish sleep quality or health status.
Same-date matching does not prove temporal order. Between-participant correlations
do not establish within-person effects, causation or campaign effectiveness.

Validate hypotheses with current Bellabeat customer research and predefined
randomized tests. Confirm product capabilities before operational messaging.
After publication, verify viewer interactions and repository links in their
hosted context. Preserve source attribution and the stated reproduction limits.

## Reproducibility and supporting documentation

- [SQL scripts](../sql/): clean-table creation, validation and analyses.
- [Cleaning log](../documentation/cleaning_log.md).
- [Data dictionary](../documentation/data_dictionary.md).
- [Source assessment](../documentation/data_sources_and_roccc.md).
- [Detailed analysis notes](analysis_notes.md).

The retained local raw files and BigQuery raw tables were not overwritten.
The [weekday SQL](../sql/10_weekday_activity.sql) and
[Tableau export queries](../sql/11_tableau_summary_exports.sql) are preserved.
The [independent QA script](../scripts/verify_portfolio.py) reproduced counts,
quartiles, exports, joins and correlations; this is not a fresh execution of the
GoogleSQL scripts in BigQuery. See [QA results](qa_results.json) and
[publication QA](../documentation/publication_qa.md) for checks and open items.
'''

parts = [intro, section('executive_summary.md'), section('methods.md'),
         section('findings.md'), '## Marketing recommendations\n\n' + rec, end]
(reports / 'final_case_study.md').write_text('\n\n'.join(parts) + '\n', encoding='utf-8')
print('Saved assembled review draft: reports/final_case_study.md')
