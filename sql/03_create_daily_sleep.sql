-- Learner's creation logic reviewed from BigQuery screenshot.
-- Creates a new table; rerunning after successful creation raises Already Exists.
CREATE TABLE `bellabeat-portfolio-513605.bellabeat_clean.daily_sleep` AS
WITH deduplicated_sleep AS (
  SELECT DISTINCT
    Id, SleepDay, TotalSleepRecords, TotalMinutesAsleep, TotalTimeInBed
  FROM `bellabeat-portfolio-513605.bellabeat_raw.daily_sleep`
)
SELECT
  TRIM(Id) AS participant_id,
  DATE(SAFE.PARSE_DATETIME('%m/%d/%Y %I:%M:%S %p', TRIM(SleepDay))) AS sleep_date,
  SAFE_CAST(NULLIF(TRIM(TotalSleepRecords), '') AS INT64) AS sleep_records,
  SAFE_CAST(NULLIF(TRIM(TotalMinutesAsleep), '') AS INT64) AS asleep_minutes,
  SAFE_CAST(NULLIF(TRIM(TotalTimeInBed), '') AS INT64) AS time_in_bed_minutes
FROM deduplicated_sleep;
