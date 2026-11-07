-- Learner-executed analyses reviewed from screenshots and summary CSV.
-- All 410 recorded sleep days retained; no activity join.
SELECT participant_id,
  COUNT(*) AS recorded_sleep_days,
  AVG(asleep_minutes) AS mean_asleep_minutes,
  STDDEV_SAMP(asleep_minutes) AS sd_asleep_minutes,
  MIN(asleep_minutes) AS minimum_asleep_minutes,
  MAX(asleep_minutes) AS maximum_asleep_minutes
FROM `bellabeat-portfolio-513605.bellabeat_clean.daily_sleep`
GROUP BY participant_id
ORDER BY recorded_sleep_days, participant_id;

SELECT COUNT(*) AS recorded_sleep_days,
  COUNT(DISTINCT participant_id) AS participants,
  AVG(asleep_minutes) AS mean_minutes_per_recorded_sleep_day
FROM `bellabeat-portfolio-513605.bellabeat_clean.daily_sleep`;

WITH participant_sleep AS (
  SELECT participant_id, COUNT(*) AS recorded_sleep_days,
    AVG(asleep_minutes) AS mean_asleep_minutes
  FROM `bellabeat-portfolio-513605.bellabeat_clean.daily_sleep`
  GROUP BY participant_id
)
SELECT DISTINCT
  PERCENTILE_CONT(mean_asleep_minutes, 0.25) OVER () AS q1_minutes,
  PERCENTILE_CONT(mean_asleep_minutes, 0.50) OVER () AS median_minutes,
  PERCENTILE_CONT(mean_asleep_minutes, 0.75) OVER () AS q3_minutes
FROM participant_sleep;

WITH participant_sleep AS (
  SELECT participant_id, COUNT(*) AS recorded_sleep_days,
    AVG(asleep_minutes) AS mean_asleep_minutes
  FROM `bellabeat-portfolio-513605.bellabeat_clean.daily_sleep`
  GROUP BY participant_id
)
SELECT 1 AS minimum_required_days, COUNT(*) AS participants,
  SUM(recorded_sleep_days) AS recorded_sleep_days,
  AVG(mean_asleep_minutes) AS participant_equal_mean_minutes
FROM participant_sleep
UNION ALL
SELECT 7, COUNT(*), SUM(recorded_sleep_days), AVG(mean_asleep_minutes)
FROM participant_sleep WHERE recorded_sleep_days >= 7
UNION ALL
SELECT 14, COUNT(*), SUM(recorded_sleep_days), AVG(mean_asleep_minutes)
FROM participant_sleep WHERE recorded_sleep_days >= 14
ORDER BY minimum_required_days;
