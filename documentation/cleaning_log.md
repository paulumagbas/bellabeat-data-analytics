# Cleaning log - work in progress

Updated: November 4, 2026 (Asia/Manila).

## Evidence and execution status

Source CSV inventory and ZIP byte comparisons were performed locally earlier in
this chat. BigQuery preview checks were executed by the learner and reviewed
from pasted SQL and screenshots. The saved clean activity table was validated
by the learner in BigQuery and verified from screenshots on November 4, 2026.
The saved clean sleep table was also validated by the learner and verified from
creation, preview, and validation screenshots in this chat.
No local source file or raw BigQuery table was modified by these previews.

## Scope

Use April 12-May 12, 2016 daily activity and daily sleep files. The original ZIP
also contains an earlier export period; periods are not combined. Activity has
940 rows and 33 distinct raw IDs; sleep has 413 rows and 24 distinct raw IDs.
Activity output selects the six validated integer measurements plus ID/date;
distance fields remain available in raw data and have not been validated for use.

## Rules and validation

| Item | Evidence | Treatment | Status |
|---|---|---|---|
| IDs and dates | No NULL, blank, or whitespace-only values in either raw table | Trim IDs, retain them as STRING; parse activity dates as DATE and sleep date-times as DATETIME then extract DATE | Preview validated |
| Date parsing | No parsing failures; both ranges 2016-04-12 to 2016-05-12 | Preserve source date labels; do not shift sleep dates or infer a timezone | Preview validated |
| Sleep duplication | Three identical five-column groups, each with two copies | SELECT DISTINCT across all five raw sleep columns; saved output has 410 rows and 24 normalized IDs | Saved table validated |
| Normalized keys | No repeated trimmed-ID/date keys in activity or deduplicated sleep preview | Target one row per participant-date | Preview validated |
| Sleep measurements | All three integer fields complete and convertible; no nonpositive record counts, negative minutes, or asleep > time in bed | Convert to INT64; no further exclusions supported by these checks | Preview validated |
| Activity measurements | Steps, calories and four minute categories complete, convertible to INT64, and nonnegative | Convert these six fields to INT64 | Preview validated |
| Zero steps | 77 of 940 participant-days (8.19%); 73 have positive calories | Retain values and rows; add zero_steps_flag | Preview validated |
| Zero calories | Four rows; all also have zero steps and 1440 sedentary minutes | Retain source value and row; add zero_calories_flag. Proposed analysis rule: omit zero values from calorie summaries and report the exclusion and denominator | Flag preview validated; analysis rule not yet executed |
| Classified minutes | Sum of four categories: range 2-1440; 478 equal 1440, 462 below (49.15%), none above or NULL | Retain total; add below_1440_minutes_flag; no imputation or automatic exclusion | Preview validated |
| Very short total | ID 4319703577, 2016-05-12: 17 steps, 257 calories, 2 lightly active minutes, other categories zero | Retain and document; partial export is a hypothesis, not a confirmed cause | Observed, cause unresolved |

Flags describe records; they do not confirm wear time, nonwear, or device failure.
No coverage cutoff is established. Future sensitivity analyses should state their
inclusion rules. Preview percentages describe participant-days, not people.

## Saved activity verification

The learner ran sql/01_create_daily_activity.sql and
sql/02_validate_saved_activity.sql against bellabeat_clean.daily_activity.
Observed saved output: 940 rows, 33 normalized participant IDs,
2016-04-12 to 2016-05-12; flags 77/4/462; zero missing-output rows,
zero inconsistent flags and no repeated keys. Both validation screenshots
match the planned checks. This confirms the saved output passes these checks;
it does not establish source measurement accuracy or participant representativeness.
The activity creation script preserves all source rows but selects only scoped
columns. It does not claim that every source column or limitation is validated.

## Saved sleep verification

The learner created bellabeat_clean.daily_sleep using the logic preserved in
sql/03_create_daily_sleep.sql. The checks in sql/04_validate_saved_sleep.sql
returned 410 rows, 24 participants, dates 2016-04-12 to 2016-05-12, zero missing
IDs/dates/measurements, zero nonpositive sleep-record counts, zero negative
minutes, zero asleep > time in bed, and no repeated participant-date keys.
An Already Exists message on a subsequent creation attempt does not require
replacing the validated table.

## Table overlap verification

The learner executed sql/05_validate_table_overlap.sql and supplied screenshots.
The activity LEFT JOIN sleep on normalized ID and source date labels preserved
940 rows: 410 matched participant-days (43.62%), 530 without sleep (56.38%),
and 24 matched participants. The reverse unmatched check returned zero rows.
Thus all 410 saved sleep records match activity; nine of the 33 activity
participants have no sleep records in this period. No row multiplication occurred.
Missing joined sleep values must remain NULL, not be replaced with zero sleep.
General activity summaries can use all 940 rows. Same-date activity/sleep
comparisons can use the 410 matched rows with their restricted coverage stated.
Temporal interpretation must be stated before relationship analysis; matching
date labels does not establish whether activity preceded sleep.

## Next steps

Participant coverage was inspected by the learner using the queries preserved
in sql/06_participant_recording_coverage.sql. Screenshots confirm 33 participant
rows; totals 940 activity days, 410 sleep days, 530 without sleep; zero
participants violating activity_days = sleep_days + activity_days_without_sleep.
Visible examples include one participant contributing four activity days and
others contributing 31. Recorded days differ, so daily-row averages weight
participants by their contribution. Averaging participant means gives each
participant equal weight but does not resolve missingness or unequal precision.
Next: compare daily-row and participant-weighted step averages descriptively.
Complete source/ROCCC documentation and data dictionary alongside the analysis.
