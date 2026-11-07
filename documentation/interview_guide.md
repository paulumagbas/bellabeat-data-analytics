# Interview explanations

## Project introduction (about 45 seconds)

I analyzed historical Fitbit activity and sleep data for a Bellabeat Leaf case
study. I used BigQuery SQL to preserve raw data, clean daily tables and validate
participant-date joins, then built a Tableau dashboard. A key decision was to
distinguish an average recorded day from an average participant. I also checked
how unequal sleep coverage changed summaries and correlations. The findings
informed three marketing hypotheses for customer research and controlled tests;
I did not claim that Fitbit observations predict Bellabeat sales or customer health.

## Participant-equal averages

"I first averaged recorded days within each participant, then averaged those
participant means. Each person therefore received equal weight. Across steps,
the daily-row mean was 7637.91, versus 7519.27 with equal participant weight.
Both are correct: one describes a recorded participant-day, the other the average
of participant means. Equal weighting does not fix missing data or make a four-day
mean as well supported as a 31-day mean."

## Recording-coverage sensitivity

"I repeated summaries with minimum counts of 1, 7 and 14 recorded days. The
participant-equal sleep mean changed from 377.45 to 424.50 and 429.50 minutes,
while participants fell from 24 to 16 and 15. That shows sensitivity to who is
included, not that the higher estimate is more accurate. These were exploratory
counts, not consecutive-day or validated completeness rules."

## Pearson correlation

"Pearson r summarizes linear association, ranging from -1 to 1. Here I correlated
participant mean steps with participant mean recorded sleep on matched dates.
The baseline r was -0.066, changing to -0.315 and -0.427 under coverage restrictions.
I reported all three and inspected a scatterplot and individual influence.
These are between-participant results, not evidence that a person's more-active
day changes their sleep, and they do not establish causation."

If asked about significance: no population-inference claim or significance test
was established. The rows used for this correlation are 24 participant summaries,
not 410 independent participants. Avoid interpreting r as a percent change.

## Participant-date join validation

"I checked keys for missing values and uniqueness after date parsing and ID
trimming. Three exact extra sleep rows were removed using all five raw columns.
I joined on both ID and date, since ID alone would match many unrelated days.
The LEFT JOIN preserved 940 activity rows: 410 matched sleep and 530 did not.
A reverse unmatched check returned zero sleep rows. That establishes coverage
and no row multiplication, not whether activity happened before sleep."

## Quartiles and outliers

"I used PERCENTILE_CONT with linear interpolation on the 33 participant means,
not an approximate quantile algorithm. Displayed quartiles were rounded: Q1
5566.87, median 7282.97, Q3 9519.67; IQR 3952.80. The highest participant mean
exceeded a 1.5-IQR fence, but statistical unusualness alone did not justify deletion."

## Source-count discrepancy

"The source description says thirty users. My selected activity file contains
33 distinct IDs and the sleep file 24. I documented both instead of changing the
counts or inventing an explanation. I treated IDs as source identifiers, not
independently verified identities or evidence of customer demographics."

## What the recommendations mean

"The data suggests questions worth testing: weekly movement messaging,
self-reported goal-based messages, and investigating sleep-recording barriers.
The historical observations are Fitbit data; the Bellabeat actions are proposals.
None was executed, and I claimed no business uplift."

## Tools and ownership

BigQuery GoogleSQL, Tableau Desktop/Public, source CSVs and Markdown documentation.
The learner executed SQL and built the dashboard with mentoring assistance;
local Python QA independently recalculated reported results. Explain the SQL and
visual choices yourself; do not describe the QA script as a Python skill you
independently implemented unless that reflects your own work and understanding.
