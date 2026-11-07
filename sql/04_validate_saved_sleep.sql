-- Learner's read-only checks reviewed from BigQuery screenshots.
SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT participant_id) AS total_participants,
  MIN(sleep_date) AS earliest_date,
  MAX(sleep_date) AS latest_date,
  COUNTIF(participant_id IS NULL OR participant_id = '') AS missing_id,
  COUNTIF(sleep_date IS NULL) AS missing_sleep_date,
  COUNTIF(sleep_records IS NULL) AS missing_sleep_records,
  COUNTIF(asleep_minutes IS NULL) AS missing_asleep_minutes,
  COUNTIF(time_in_bed_minutes IS NULL) AS missing_time_in_bed,
  COUNTIF(sleep_records <= 0) AS nonpositive_sleep_records,
  COUNTIF(asleep_minutes < 0) AS negative_asleep_minutes,
  COUNTIF(time_in_bed_minutes < 0) AS negative_time_in_bed,
  COUNTIF(asleep_minutes > time_in_bed_minutes) AS asleep_exceeds_time_in_bed
FROM `bellabeat-portfolio-513605.bellabeat_clean.daily_sleep`;

SELECT participant_id, sleep_date, COUNT(*) AS records_per_key
FROM `bellabeat-portfolio-513605.bellabeat_clean.daily_sleep`
GROUP BY participant_id, sleep_date
HAVING COUNT(*) > 1;
