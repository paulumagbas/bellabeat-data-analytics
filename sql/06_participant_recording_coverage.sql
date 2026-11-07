-- Learner's coverage analysis reviewed from BigQuery screenshots.
SELECT
  a.participant_id,
  COUNT(*) AS activity_days,
  COUNT(s.sleep_date) AS sleep_days,
  COUNTIF(s.sleep_date IS NULL) AS activity_days_without_sleep,
  MIN(a.activity_date) AS first_activity_date,
  MAX(a.activity_date) AS last_activity_date
FROM `bellabeat-portfolio-513605.bellabeat_clean.daily_activity` AS a
LEFT JOIN `bellabeat-portfolio-513605.bellabeat_clean.daily_sleep` AS s
  ON a.participant_id = s.participant_id
  AND a.activity_date = s.sleep_date
GROUP BY a.participant_id
ORDER BY sleep_days, activity_days, a.participant_id;

WITH participant_coverage AS (
  SELECT
    a.participant_id,
    COUNT(*) AS activity_days,
    COUNT(s.sleep_date) AS sleep_days,
    COUNTIF(s.sleep_date IS NULL) AS activity_days_without_sleep
  FROM `bellabeat-portfolio-513605.bellabeat_clean.daily_activity` AS a
  LEFT JOIN `bellabeat-portfolio-513605.bellabeat_clean.daily_sleep` AS s
    ON a.participant_id = s.participant_id
    AND a.activity_date = s.sleep_date
  GROUP BY a.participant_id
)
SELECT
  COUNT(*) AS total_participants,
  SUM(activity_days) AS total_activity_days,
  SUM(sleep_days) AS total_sleep_days,
  SUM(activity_days_without_sleep) AS total_days_without_sleep,
  COUNTIF(sleep_days + activity_days_without_sleep != activity_days)
    AS inconsistent_participants
FROM participant_coverage;
