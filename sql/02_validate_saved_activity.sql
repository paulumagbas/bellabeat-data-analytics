-- Run after 01_create_daily_activity.sql. Both statements are read-only.
SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT participant_id) AS unique_participants,
  MIN(activity_date) AS earliest_date,
  MAX(activity_date) AS latest_date,
  COUNTIF(zero_steps_flag) AS zero_step_days,
  COUNTIF(zero_calories_flag) AS zero_calorie_days,
  COUNTIF(below_1440_minutes_flag) AS below_1440_days,
  COUNTIF(participant_id IS NULL OR participant_id = '' OR activity_date IS NULL
    OR total_steps IS NULL OR calories IS NULL OR very_active_minutes IS NULL
    OR fairly_active_minutes IS NULL OR lightly_active_minutes IS NULL
    OR sedentary_minutes IS NULL OR total_classified_minutes IS NULL
    OR zero_steps_flag IS NULL OR zero_calories_flag IS NULL
    OR below_1440_minutes_flag IS NULL) AS rows_with_missing_output,
  COUNTIF(zero_steps_flag != (total_steps = 0)
    OR zero_calories_flag != (calories = 0)
    OR below_1440_minutes_flag != (total_classified_minutes < 1440))
    AS inconsistent_flags
FROM `bellabeat-portfolio-513605.bellabeat_clean.daily_activity`;

-- Expected: no rows.
SELECT participant_id, activity_date, COUNT(*) AS records_per_key
FROM `bellabeat-portfolio-513605.bellabeat_clean.daily_activity`
GROUP BY participant_id, activity_date
HAVING COUNT(*) > 1;
