-- GoogleSQL. Four read-only exports for the existing Tableau workbook.
-- Export each statement independently to its indicated filename.

-- participant_steps_summary.csv
SELECT participant_id, COUNT(*) AS recorded_days,
  AVG(total_steps) AS participant_mean_steps
FROM `bellabeat-portfolio-513605.bellabeat_clean.daily_activity`
GROUP BY participant_id ORDER BY participant_mean_steps;

-- Sleep Analysis Participant-Level Summary.csv
SELECT participant_id, COUNT(*) AS recorded_sleep_days,
  AVG(asleep_minutes) AS mean_asleep_minutes,
  AVG(asleep_minutes) / 60.0 AS mean_asleep_hours,
  MIN(asleep_minutes) AS minimum_asleep_minutes,
  MAX(asleep_minutes) AS maximum_asleep_minutes
FROM `bellabeat-portfolio-513605.bellabeat_clean.daily_sleep`
GROUP BY participant_id ORDER BY recorded_sleep_days, participant_id;

-- Activity Sleep Analysis Participant Level Matched Days.csv
WITH matched_days AS (
  SELECT a.participant_id, a.total_steps, s.asleep_minutes
  FROM `bellabeat-portfolio-513605.bellabeat_clean.daily_activity` AS a
  INNER JOIN `bellabeat-portfolio-513605.bellabeat_clean.daily_sleep` AS s
    ON a.participant_id = s.participant_id AND a.activity_date = s.sleep_date
)
SELECT participant_id, COUNT(*) AS matched_days,
  AVG(total_steps) AS mean_steps_on_matched_days,
  AVG(asleep_minutes) AS mean_asleep_minutes_on_matched_days
FROM matched_days GROUP BY participant_id ORDER BY matched_days, participant_id;

-- weekday_steps_same_participants.csv: second statement of 10_weekday_activity.sql.
