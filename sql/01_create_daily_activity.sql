-- GoogleSQL. Run after creating bellabeat_clean in the raw dataset's location.
-- Creates a new table; deliberately fails if the destination already exists.
-- Saved BigQuery output verified from learner screenshots: 940 rows;
-- flags 77 / 4 / 462. See documentation/cleaning_log.md.
CREATE TABLE `bellabeat-portfolio-513605.bellabeat_clean.daily_activity` AS
WITH checked_activity AS (
  SELECT
    TRIM(Id) AS participant_id,
    SAFE.PARSE_DATE('%m/%d/%Y', TRIM(ActivityDate)) AS activity_date,
    SAFE_CAST(NULLIF(TRIM(TotalSteps), '') AS INT64) AS total_steps,
    SAFE_CAST(NULLIF(TRIM(Calories), '') AS INT64) AS calories,
    SAFE_CAST(NULLIF(TRIM(VeryActiveMinutes), '') AS INT64) AS very_active_minutes,
    SAFE_CAST(NULLIF(TRIM(FairlyActiveMinutes), '') AS INT64) AS fairly_active_minutes,
    SAFE_CAST(NULLIF(TRIM(LightlyActiveMinutes), '') AS INT64) AS lightly_active_minutes,
    SAFE_CAST(NULLIF(TRIM(SedentaryMinutes), '') AS INT64) AS sedentary_minutes
  FROM `bellabeat-portfolio-513605.bellabeat_raw.daily_activity`
),
classified_activity AS (
  SELECT *,
    very_active_minutes + fairly_active_minutes + lightly_active_minutes
      + sedentary_minutes AS total_classified_minutes
  FROM checked_activity
)
SELECT *,
  CASE WHEN total_steps = 0 THEN TRUE ELSE FALSE END AS zero_steps_flag,
  CASE WHEN calories = 0 THEN TRUE ELSE FALSE END AS zero_calories_flag,
  CASE WHEN total_classified_minutes < 1440 THEN TRUE ELSE FALSE END
    AS below_1440_minutes_flag
FROM classified_activity;
