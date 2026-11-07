-- Learner executed these checks in BigQuery; screenshots reviewed in chat.
-- Observed: 940 joined rows, 410 matched, 530 unmatched, 24 matched participants.
SELECT
  COUNT(*) AS joined_rows,
  COUNTIF(s.participant_id IS NOT NULL) AS matched_activity_days,
  COUNTIF(s.participant_id IS NULL) AS activity_days_without_sleep,
  COUNT(DISTINCT s.participant_id) AS matched_participants
FROM `bellabeat-portfolio-513605.bellabeat_clean.daily_activity` AS a
LEFT JOIN `bellabeat-portfolio-513605.bellabeat_clean.daily_sleep` AS s
  ON a.participant_id = s.participant_id
  AND a.activity_date = s.sleep_date;

-- Observed: zero rows; all saved sleep keys match activity keys.
SELECT s.*
FROM `bellabeat-portfolio-513605.bellabeat_clean.daily_sleep` AS s
LEFT JOIN `bellabeat-portfolio-513605.bellabeat_clean.daily_activity` AS a
  ON s.participant_id = a.participant_id
  AND s.sleep_date = a.activity_date
WHERE a.participant_id IS NULL;
