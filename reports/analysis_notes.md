# Analysis notes - work in progress

## Participant step distribution

Evidence: learner-executed BigQuery queries/screenshots and exported
participant_steps_summary.csv. Quartiles independently checked from that CSV
using inclusive linear interpolation and reproduced by the learner using
PERCENTILE_CONT. Source SQL: sql/07_participant_step_distribution.sql.

All 940 activity rows and 33 participants retained, including zero-step days.
No sleep join and no coverage cutoff. Participants contribute 4-31 recorded days.

| Statistic | Steps |
|---|---:|
| Daily-row mean | 7637.910638297861 |
| Mean of participant means | 7519.272677980972 |
| Minimum participant mean | 916.1290322580645 |
| Q1 of participant means | 5566.870967741936 |
| Median participant mean | 7282.966666666666 |
| Q3 of participant means | 9519.666666666668 |
| Maximum participant mean | 16040.032258064515 |
| IQR | 3952.795698924732 |

These summaries measure between-participant differences in recorded average
steps, not within-participant daily variation. Participant-equal weighting
does not correct missingness or make the sample representative of Bellabeat
customers. Mean/median differences alone do not establish distribution shape.

The minimum and maximum means both use 31 days; identical counts do not prove
equally complete tracking. The highest mean exceeds the 1.5-IQR upper fence
(15448.860215053766); retain it because statistical unusualness is not evidence
of a data error. No causal or marketing-effectiveness claims are supported.

Provisional dashboard choice: median participant mean with participant mean as
supporting context, plus a participant dot plot and recorded-days tooltips.
Final chart choices remain pending broader analysis.

Next analysis: participant-equal weekday means with contributing participant
and recorded-day counts. Do not infer advertising timing from daily steps.

## Recorded sleep duration and variability

Learner-executed BigQuery results reviewed in chat; source queries preserved in
sql/08_sleep_duration_and_variability.sql. No missing sleep days imputed.
All-participant baseline: 24 participants, 410 days, 1-31 days per participant.
Daily-row mean: 419.1731707317073 minutes. Participant-equal mean:
377.4463856256551 minutes (6.2907730937609205 hours).
Participant-mean quartiles: 336.28125 / 417.2407407407407 / 449.28125 minutes;
IQR 113 minutes. These are not quartiles of individual daily records.

Exploratory recording-count sensitivity (nested groups, not consecutive days):

| Minimum recorded days | Participants | Recorded days | Participant-equal mean minutes |
|---|---:|---:|---:|
| 1 | 24 | 410 | 377.4463856256551 |
| 7 | 16 | 384 | 424.49666177181604 |
| 14 | 15 | 376 | 429.50477255660377 |

Thresholds are comparisons, not validated completeness criteria. Higher means
after restriction establish selection sensitivity, not improved accuracy.

Variability export at C:/Users/Nitro/Downloads/Sleep Analysis Participant-Level
Sleep Duration Variability.csv independently inspected: 24 unique IDs, 410 days,
23 nonmissing sample SDs. ID 2320127002 has one observation and a blank exported
SD representing SQL NULL; do not replace it with zero. Highest SD:
1644430081, 334.75264499826341 minutes from four days (119-796 minutes).
Comparison: 1927972279 mean 417, SD 219.23503369671553, five days;
4702921684 mean 417.48148148148141, SD 66.524934810692983, 27 days.
SD describes within-participant recorded duration variability, not bedtime
regularity, health status, or sleep quality. Coverage limits interpretation.

## Activity-sleep participant correlation and influence

Source: C:/Users/Nitro/Downloads/Activity Sleep Analysis ParticipantLevel Matched
Days.csv, 24 participant summaries of 410 same-date matched days. Independently
checked participant-equal means: 7879.70001090234 steps and 377.4463856256551
sleep minutes. Learner's BigQuery correlation sensitivity query is preserved in
sql/09_activity_sleep_correlation.sql; outputs independently reproduced locally.

| Minimum matched days | Participants | Days | Pearson r | Single-participant omission range |
|---|---:|---:|---:|---|
| 1 | 24 | 410 | -0.0663323518056091 | -0.169945 to 0.048287 |
| 7 | 16 | 384 | -0.3148490504130188 | -0.437335 to -0.165953 |
| 14 | 15 | 376 | -0.42681764288372254 | -0.599049 to -0.321138 |

Omission ranges are diagnostics, not confidence intervals. No participant was
deleted from source or cleaned tables. Largest absolute single-omission changes:
baseline: omit 1844505072 (three days), r becomes 0.048287;
7-day subset: omit 3977333714 (28 days), r becomes -0.165953;
14-day subset: omit 4445114986 (28 days), r becomes -0.599049.
These are influence findings, not proof of incorrect data or grounds for exclusion.
Within the 7-day and 14-day subsets, individual omissions retain a negative sign
but change magnitude. Baseline direction is fragile. Samples are small and
coverage-dependent; no causal or within-person conclusion follows.

Diagnostic PNG visually reviewed: visualizations/activity_sleep_diagnostic.png.
Shared axes and equal point sizes preserve comparisons; point color encodes
coverage category. Generator: scripts/plot_activity_sleep.mjs. Full local
leave-one-out results: reports/activity_sleep_leave_one_out.csv.
