-- GoogleSQL. Preserves learner-validated baseline and same-participant analysis.
-- Includes zero steps; no sleep join. DAYOFWEEK: Sunday=1, Saturday=7.
WITH participant_weekday AS (
  SELECT participant_id,
    EXTRACT(DAYOFWEEK FROM activity_date) AS weekday_number,
    COUNT(*) AS recorded_days,
    AVG(total_steps) AS participant_weekday_mean_steps
  FROM `bellabeat-portfolio-513605.bellabeat_clean.daily_activity`
  GROUP BY participant_id, weekday_number
)
SELECT weekday_number, COUNT(*) AS contributing_participants,
  SUM(recorded_days) AS recorded_days,
  AVG(participant_weekday_mean_steps) AS participant_equal_mean_steps
FROM participant_weekday
GROUP BY weekday_number ORDER BY weekday_number;

-- Export this second result as weekday_steps_same_participants.csv.
-- Eligibility means at least one observation in each weekday category,
-- not 31 complete days or seven consecutive days.
WITH participant_weekday AS (
  SELECT participant_id,
    EXTRACT(DAYOFWEEK FROM activity_date) AS weekday_number,
    COUNT(*) AS recorded_days,
    AVG(total_steps) AS participant_weekday_mean_steps
  FROM `bellabeat-portfolio-513605.bellabeat_clean.daily_activity`
  GROUP BY participant_id, weekday_number
),
eligible_participants AS (
  SELECT participant_id FROM participant_weekday
  GROUP BY participant_id
  HAVING COUNT(DISTINCT weekday_number) = 7
)
SELECT pw.weekday_number, COUNT(*) AS contributing_participants,
  SUM(pw.recorded_days) AS recorded_days,
  AVG(pw.participant_weekday_mean_steps) AS participant_equal_mean_steps
FROM participant_weekday AS pw
INNER JOIN eligible_participants AS e ON pw.participant_id = e.participant_id
GROUP BY pw.weekday_number ORDER BY pw.weekday_number;
-- Expected: seven rows, 32 contributing participants each, 936 total days.
