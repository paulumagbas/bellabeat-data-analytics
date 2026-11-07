-- Same-date, between-participant analysis; does not establish temporal order.
WITH matched_days AS (
  SELECT a.participant_id, a.activity_date, a.total_steps, s.asleep_minutes
  FROM `bellabeat-portfolio-513605.bellabeat_clean.daily_activity` AS a
  INNER JOIN `bellabeat-portfolio-513605.bellabeat_clean.daily_sleep` AS s
    ON a.participant_id = s.participant_id AND a.activity_date = s.sleep_date
),
participant_matched AS (
  SELECT participant_id, COUNT(*) AS matched_days,
    AVG(total_steps) AS mean_steps_on_matched_days,
    AVG(asleep_minutes) AS mean_asleep_minutes_on_matched_days
  FROM matched_days GROUP BY participant_id
)
SELECT 1 AS minimum_matched_days, COUNT(*) AS participants,
  SUM(matched_days) AS matched_days,
  CORR(mean_steps_on_matched_days, mean_asleep_minutes_on_matched_days) AS pearson_r
FROM participant_matched
UNION ALL
SELECT 7, COUNT(*), SUM(matched_days),
  CORR(mean_steps_on_matched_days, mean_asleep_minutes_on_matched_days)
FROM participant_matched WHERE matched_days >= 7
UNION ALL
SELECT 14, COUNT(*), SUM(matched_days),
  CORR(mean_steps_on_matched_days, mean_asleep_minutes_on_matched_days)
FROM participant_matched WHERE matched_days >= 14
ORDER BY minimum_matched_days;
