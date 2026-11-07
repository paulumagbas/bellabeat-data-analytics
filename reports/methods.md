# Methods

This study selected Fitbit daily activity and sleep files covering April 12-May
12, 2016 because their overlapping dates support separate descriptive analyses
and matched-date comparisons relevant to the case-study product, Bellabeat Leaf.

Preparation used Google BigQuery SQL. Original files and raw tables were
preserved, with transformations saved in separate clean tables. Participant IDs
were trimmed and retained as text, dates were explicitly parsed, and selected
numeric measurements were converted to integers. Missing values, failed
conversions, negative measurements, logical inconsistencies and participant-date
uniqueness were checked.

The raw sleep table contained 413 rows. Retaining one copy of each distinct
combination across all five source fields removed three extra copies, leaving
410 participant-day records from 24 participant IDs. The activity table retained
940 rows from 33 IDs. Zero-step records were retained and flagged because their
causes could not be verified. Zero-calorie values and classified-minute totals
below 1440 were also flagged; classified minutes were not treated as wear time.

Daily-row and participant-equal means were distinguished. Participant-equal
summaries prevented unequal recording counts from determining participant
weights. Weekday sensitivity analysis retained the same 32 participants observed
in all seven weekday categories. Exploratory minimum counts of 1, 7 and 14
recorded days were compared for sleep summaries and matched participant-level
correlations; these thresholds were not validated completeness standards.

Activity and sleep were joined on ID and equal date labels. A LEFT JOIN retained
940 activity rows without multiplication; all 410 sleep rows matched activity,
yielding 24 matched participants. Equal date labels did not establish temporal
order. Pearson correlations described between-participant averages, with
coverage and individual-omission sensitivity checks. Tableau chart counts,
values and references were checked against SQL outputs, and coverage highlighting
preserved the displayed population.
