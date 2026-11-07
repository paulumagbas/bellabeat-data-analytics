# Bellabeat Leaf: Activity Patterns and Recording Limitations

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


## Executive summary

This case study explores Fitbit activity and sleep records to develop marketing
hypotheses for Bellabeat Leaf. Leaf was selected because its activity and
sleep-tracking features, as described in the case-study brief, align with the
available measurements.

Using Google BigQuery SQL for cleaning and analysis and Tableau for visualization,
the project examined 940 activity records from 33 participant IDs and 410
deduplicated sleep records from 24 participant IDs, covering April 12-May 12, 2016.

Two findings inform the proposed marketing tests. Participants' mean recorded
daily steps ranged from approximately 916 to 16,040, suggesting that research
into differing activity goals could be useful. Among the same 32 participants
represented across all weekdays, Saturday had the highest participant-equal
mean steps (8303), while Sunday had the lowest (6950).

The data is historical, the sample is small, recording coverage is uneven, and
participants are not verified Bellabeat customers. Step counts do not reveal
customer motivations, and weekday averages do not establish individual routines.

Bellabeat could research self-reported goals and test preference-based messages
and weekly movement messaging against general wellness messaging. Randomized
tests with predefined outcomes are needed; these records establish no campaign
effectiveness or sales improvement.

## Methods

This study selected Fitbit daily activity and sleep files covering April 12-May
12, 2016 because their overlapping dates support separate descriptive analyses
and matched-date comparisons relevant to the case-study product, Bellabeat Leaf.

Preparation used Google BigQuery SQL. Original files and raw tables were
preserved, with transformations saved in separate clean tables. Participant IDs
were trimmed and retained as text, dates were explicitly parsed, and selected
numeric measurements were converted to integers. Missing values, failed
conversions, negative measurements, logical inconsistencies and participant-date
uniqueness were checked.

The raw sleep table contained 413 rows. Retaining one copy of each distinct
combination across all five source fields removed three extra copies, leaving
410 participant-day records from 24 participant IDs. The activity table retained
940 rows from 33 IDs. Zero-step records were retained and flagged because their
causes could not be verified. Zero-calorie values and classified-minute totals
below 1440 were also flagged; classified minutes were not treated as wear time.

Daily-row and participant-equal means were distinguished. Participant-equal
summaries prevented unequal recording counts from determining participant
weights. Weekday sensitivity analysis retained the same 32 participants observed
in all seven weekday categories. Exploratory minimum counts of 1, 7 and 14
recorded days were compared for sleep summaries and matched participant-level
correlations; these thresholds were not validated completeness standards.

Activity and sleep were joined on ID and equal date labels. A LEFT JOIN retained
940 activity rows without multiplication; all 410 sleep rows matched activity,
yielding 24 matched participants. Equal date labels did not establish temporal
order. Pearson correlations described between-participant averages, with
coverage and individual-omission sensitivity checks. Tableau chart counts,
values and references were checked against SQL outputs, and coverage highlighting
preserved the displayed population.

## Findings

### Participant activity

The activity analysis included 33 participants whose mean recorded daily steps
ranged from approximately 916 to 16040. The median participant mean was 7283
steps, while the middle half of participant means ranged from approximately
5567 to 9520 steps. This describes variation between participants' recorded
averages, rather than variation across all individual daily records. Activity
goals and motivations require separate customer research.

### Weekday activity patterns

Saturday had the highest participant-equal step average and Sunday the lowest.
The ranking remained unchanged when analysis was restricted to the same 32
participants represented in all seven weekday categories, using 936 recorded
participant-days. Saturday averaged 8303 steps and Sunday 6950. Each participant
received equal weight within each weekday. The unchanged ranking reduces concern
about differing participant composition across weekdays; recording completeness
and reasons for the pattern remain unresolved.

### Sleep recording coverage

Sleep analysis included 24 participants and 410 recorded participant-days, with
1-31 days per participant. The participant-equal mean recorded daily sleep
duration increased from 377.45 minutes for all 24 participants to 424.50 minutes
for 16 participants with at least seven recorded days, and 429.50 minutes for
15 participants with at least 14 days. These nested sensitivity comparisons
show that estimates depend on participant selection. The thresholds are
observation counts, not consecutive-day or validated completeness requirements.

### Supporting exploration: activity and sleep

On same-date matched records, the correlation between participant mean steps
and participant mean recorded sleep was -0.066 (24 participants/410 days).
Restricting to at least seven matched days gave -0.315 (16/384); at least
14 gave -0.427 (15/376). In the seven-day subset, omitting one participant
with 28 matched days changed r to -0.166 (15/356). This was an influence check,
not a cleaning exclusion. Estimates are sensitive to coverage and individual
observations. They describe between-participant linear associations, not
within-person effects, temporal order or causation.

## Marketing recommendations

### 1. Test messaging about movement across the week

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


## Visual communication

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

