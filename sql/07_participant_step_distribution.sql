-- Descriptive queries executed by the learner and reviewed from screenshots.
-- Includes all 940 recorded days, including zero steps; no sleep join.
SELECT COUNT(*) AS recorded_days,
  COUNT(DISTINCT participant_id) AS participants,
  AVG(total_steps) AS mean_steps_per_recorded_day
FROM `bellabeat-portfolio-513605.bellabeat_clean.daily_activity`;

WITH participant_steps AS (
  SELECT participant_id, COUNT(*) AS recorded_days,
    AVG(total_steps) AS participant_mean_steps
  FROM `bellabeat-portfolio-513605.bellabeat_clean.daily_activity`
  GROUP BY participant_id
)
SELECT COUNT(*) AS participants, SUM(recorded_days) AS recorded_days,
  MIN(recorded_days) AS fewest_days_per_participant,
  MAX(recorded_days) AS most_days_per_participant,
  AVG(participant_mean_steps) AS mean_of_participant_means
FROM participant_steps;

WITH participant_steps AS (
  SELECT participant_id, COUNT(*) AS recorded_days,
    AVG(total_steps) AS participant_mean_steps
  FROM `bellabeat-portfolio-513605.bellabeat_clean.daily_activity`
  GROUP BY participant_id
)
SELECT DISTINCT
  PERCENTILE_CONT(participant_mean_steps, 0.25) OVER () AS q1_steps,
  PERCENTILE_CONT(participant_mean_steps, 0.50) OVER () AS median_steps,
  PERCENTILE_CONT(participant_mean_steps, 0.75) OVER () AS q3_steps
FROM participant_steps;
