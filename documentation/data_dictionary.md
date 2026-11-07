# Data dictionary

Reviewed learner definitions extended to the fields selected for this project.
Types below refer to clean BigQuery tables; all raw table fields were imported
as STRING. No source device-intensity thresholds have been established here.

## Grain and keys

- daily_activity: one row per participant/activity date; 940 validated rows.
  Key: participant_id + activity_date.
- daily_sleep: one row per participant/source sleep date after exact five-column
  deduplication; 410 validated rows. Key: participant_id + sleep_date.
- Join: participant_id and equal source date labels. Matching dates does not
  establish whether activity preceded sleep. No timezone was inferred.
- Counts of participants mean distinct source IDs, not independently verified
  human identities. Missing joined sleep remains NULL, not zero minutes.

## Shared identifier

| Field | Type | Source / transformation | Meaning and caution |
|---|---|---|---|
| participant_id | STRING | TRIM(Id) | Pseudonymous source participant/export identifier used to link records. Do not sum or average; not unique without the date. No independent identity validation. |

## Clean daily_activity

Numeric source strings are trimmed, blank-to-NULL normalized with NULLIF, and
converted with SAFE_CAST to INT64. Conversion failures would become NULL;
the executed source/output checks found none in these selected measurements.

| Field | Type / unit | Source / calculation | Meaning and caution |
|---|---|---|---|
| activity_date | DATE | SAFE.PARSE_DATE('%m/%d/%Y', TRIM(ActivityDate)) | Source activity-day label. Selected range 2016-04-12 to 2016-05-12; does not imply every participant contributed each day. |
| total_steps | INT64 / steps | TotalSteps | Recorded daily steps. Zero is retained and does not establish inactivity or nonwear. |
| calories | INT64 / source calorie units | Calories | Source daily calorie-expenditure estimate, not food intake or measured energy expenditure. Zero values retained and flagged; omit from calorie-specific summaries under the proposed analysis rule, reporting denominator. No clinical interpretation. |
| very_active_minutes | INT64 / minutes | VeryActiveMinutes | Source very-active classification. Not a clinical intensity category established by this project. |
| fairly_active_minutes | INT64 / minutes | FairlyActiveMinutes | Source fairly-active classification; do not infer a new intensity threshold. |
| lightly_active_minutes | INT64 / minutes | LightlyActiveMinutes | Source lightly-active classification; not equivalent to a workout duration. |
| sedentary_minutes | INT64 / minutes | SedentaryMinutes | Minutes classified as sedentary by the source. Not independently validated sitting time or wear time. |
| total_classified_minutes | INT64 / minutes | Sum of the four minute categories above | Total recorded category minutes for the participant-day. Not total exercise or verified wear time. A total of 1440 does not prove complete tracking. Do not automatically fill shortfalls or add sleep minutes. |
| zero_steps_flag | BOOL | CASE WHEN total_steps = 0 THEN TRUE ELSE FALSE END | Descriptive flag, not a deletion rule. Validated TRUE count: 77. |
| zero_calories_flag | BOOL | CASE WHEN calories = 0 THEN TRUE ELSE FALSE END | Descriptive flag for investigation/analysis inclusion. Validated TRUE count: 4. |
| below_1440_minutes_flag | BOOL | CASE WHEN total_classified_minutes < 1440 THEN TRUE ELSE FALSE END | Sum below 24 hours; not a confirmed nonwear flag. Validated TRUE count: 462. |

The three CASE expressions would return FALSE for a NULL condition; their
interpretation depends on the separately validated absence of missing inputs.
Distance fields remain in raw data; they were not selected or validated for use.

## Clean daily_sleep

SELECT DISTINCT is applied to Id, SleepDay, TotalSleepRecords,
TotalMinutesAsleep and TotalTimeInBed before normalization. Numeric conversion
uses the same trimmed blank-to-NULL SAFE_CAST pattern as activity.

| Field | Type / unit | Source / calculation | Meaning and caution |
|---|---|---|---|
| sleep_date | DATE | DATE(SAFE.PARSE_DATETIME('%m/%d/%Y %I:%M:%S %p', TRIM(SleepDay))) | Date extracted from full source sleep date-time. Not inferred bedtime or confirmed date of sleep onset; no day shift applied. |
| sleep_records | INT64 / records | TotalSleepRecords | Source count of sleep records summarized for the date (observed 1-3). Not the number of daily table rows and not necessarily awakenings. |
| asleep_minutes | INT64 / minutes | TotalMinutesAsleep | Total recorded asleep minutes for the participant-date; may summarize multiple sessions. Not necessarily one continuous overnight sleep, usual duration or sleep quality. |
| time_in_bed_minutes | INT64 / minutes | TotalTimeInBed | Source recorded time-in-bed total for that date. Not synonymous with asleep minutes or independently verified time in bed. |

## Analytical summaries and Tableau fields

These are query/calculated measures, not additional clean-table columns.
CSV exports carry values but no enforced schema: keep IDs as text in Tableau.

| Field / measure | Grain / calculation | Meaning and caution |
|---|---|---|
| recorded_days / activity_days | Participant: COUNT(*) in activity | Number of recorded dates, not confirmed wear days. |
| participant_mean_steps | Participant: AVG(total_steps) | Mean over that participant's recorded activity days, including zero steps. |
| mean of participant means | AVG(participant_mean_steps) over 33 rows | Equal participant weight; not the mean of all 940 daily rows. |
| participant-mean quartiles | PERCENTILE_CONT at 0.25, 0.50, 0.75 across participant means | Linear interpolation; between-participant summaries, not daily step quartiles. |
| weekday_number | EXTRACT(DAYOFWEEK FROM activity_date) | 1 Sunday through 7 Saturday; display in calendar order. |
| participant_weekday_mean_steps | Participant + weekday: AVG(total_steps) | Each participant's mean on observed instances of that weekday. |
| participant_equal_mean_steps | Weekday: AVG(participant_weekday_mean_steps) | Equal weight among contributing participants. Dashboard sample requires all seven weekday categories: 32 participants/936 days, not seven consecutive dates. |
| contributing_participants | Weekday: count of participant-weekday summary rows | 32 for each dashboard weekday; do not sum across weekdays to get unique participants. |
| recorded_days in weekday export | Weekday: SUM(participant-weekday day counts) | Participant-day denominator; seven dashboard counts sum to 936. |
| recorded_sleep_days | Participant: COUNT(*) in sleep | Count of observed sleep dates, not consecutive or complete sleep tracking. |
| mean_asleep_minutes | Participant: AVG(asleep_minutes) | Mean recorded daily sleep minutes. |
| mean_asleep_hours | mean_asleep_minutes / 60.0 | Decimal hours; 6.5 hours means 6 hours 30 minutes. |
| minimum_asleep_minutes / maximum_asleep_minutes | Participant: MIN / MAX(asleep_minutes) | Observed endpoints, not proven physiological limits. |
| sd_asleep_minutes | Participant: STDDEV_SAMP(asleep_minutes) | Within-participant recorded duration variability. NULL with one record; do not replace with zero. Not bedtime regularity or sleep quality. |
| matched_days | Participant: COUNT(*) after ID/date INNER JOIN | Number of paired activity/sleep dates; all 24 summaries sum to 410. |
| mean_steps_on_matched_days | Participant: AVG(total_steps) after join | Steps averaged only on the same dates used for sleep, not necessarily all participant activity days. |
| mean_asleep_minutes_on_matched_days | Participant: AVG(asleep_minutes) after join | Sleep averaged over matched dates. All saved sleep dates match activity here. |
| Recording Coverage Group | Matched participant summary: <7, <14, otherwise | 1-6, 7-13, 14+ matched days. Exploratory descriptive categories, not validity labels. |
| pearson_r | CORR of paired participant mean steps and sleep | Between-participant linear association. Coverage subsets change the sample; not within-person association, temporal order or causation. |

## Interpretation controls

Preserve full calculation precision and round only displayed values. Summary
tables have different grains and populations; do not join/re-average them
without specifying the intended weights. Dashboard highlighting preserves
observations, whereas filtering may require dynamic counts and annotations.
See cleaning_log.md, data_sources_and_roccc.md and ../reports/analysis_notes.md
for evidence, validation results, provenance and limitations.
