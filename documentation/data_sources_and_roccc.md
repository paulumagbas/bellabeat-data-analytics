# Data sources and ROCCC assessment

Prepared November 6, 2026. Learner's Reliable, Current and Comprehensive
assessments reviewed in chat; provenance findings added by assistant.

## Sources and provenance

- Project acquisition source: Mobius, FitBit Fitness Tracker Data, Kaggle:
  https://www.kaggle.com/datasets/arashnic/fitbit
- Original research deposit identified: Furberg, Robert; Brinton, Julia;
  Keating, Michael; Ortiz, Alexa (RTI International). (2016). Crowd-sourced
  Fitbit datasets 03.12.2016-05.12.2016 (v1). Zenodo.
  https://doi.org/10.5281/zenodo.53894
- Case-study brief: Case Study 2 How can a wellness company play it smart.pdf,
  supplied locally. Provides the historical business scenario and identifies
  the Kaggle source; it is not evidence of current product capabilities.

The Zenodo record describes Amazon Mechanical Turk survey respondents and
consenting eligible Fitbit users. Its export archive names match the two periods
present in the supplied Kaggle ZIP. This documents relevant original research
provenance; the project has not compared the local CSV bytes against Zenodo's
archives, so end-to-end file identity and redistribution transformations remain
unverified. The Kaggle page was reachable but did not yield readable page text
to the web tool during this review.

The brief describes the Kaggle data as CC0/public domain. That statement is
attributed to the supplied brief; current dataset-specific license metadata
was not independently retrieved during this provenance review. Do not infer a
license from generic platform terms or treat a public license as proof of
representativeness or a reason to identify participants.

## File scope and observed counts

Local Case Study.zip contains March 12-April 11 and April 12-May 12 exports.
Only the April 12-May 12 daily activity and sleep CSVs were selected for this
project. Separate supplied CSVs were verified byte-identical to their matching
entries in the local ZIP; originals were preserved.

| Selected file | Raw rows | Raw distinct IDs | Selected dates |
|---|---:|---:|---|
| dailyActivity_merged.csv | 940 | 33 | 2016-04-12 to 2016-05-12 |
| sleepDay_merged.csv | 413 | 24 | 2016-04-12 to 2016-05-12 |

Sleep output has 410 rows after retaining one copy of each distinct five-column
raw row. All 410 match activity by normalized ID and date label. Participant
counts are observed distinct-ID counts, not independently verified identities.
The source description refers to thirty users, while our selected activity file
contains 33 distinct IDs; this discrepancy is documented, not resolved by guessing.
Exact download date and Kaggle version were not recorded in the chat.

## ROCCC

| Dimension | Assessment and implication |
|---|---|
| Reliable | Local structure, keys, types, duplicates and selected measurement rules were checked. Source documentation identifies Mechanical Turk recruitment; the sampling frame, representativeness and device measurement accuracy are not independently validated. Small and uneven coverage limits generalization. Cleaning does not establish external validity. |
| Original | Kaggle is the acquisition/redistribution source, not the research authorship. An identifiable 2016 Zenodo deposit supplies research attribution and matching export periods. Source-to-local byte identity is unverified. Originality concerns provenance, not whether the sample consists of Bellabeat customers. |
| Comprehensive | Selected daily files support descriptive steps, weekday patterns, recorded sleep durations, coverage and exploratory same-date associations. They do not supply sufficient demographics, stated goals, motivations, ad responses, purchases or Bellabeat customer behaviour. Findings do not establish sleep quality or bedtime regularity. Other archive files were outside the selected scope. |
| Current | Selected records are from April-May 2016, about ten years before the 2026 analysis. Technology, features and behaviour may have changed. Use as historical exploratory evidence and validate proposed marketing hypotheses with current Bellabeat-specific research. |
| Cited | Acquisition URL, original deposit DOI, authors, year, version and selected files are documented. Citation permits traceability, not proof of accuracy. Preserve SQL, cleaning log and analysis notes alongside attribution. Download/version uncertainty and the participant-count discrepancy remain explicit. |

## Suitability conclusion

Suitable for a bounded learning/portfolio exercise and hypothesis generation.
Insufficient alone to estimate current Bellabeat customer behaviour, infer
women-specific patterns, make medical claims, establish activity-sleep causation,
or forecast marketing returns. Proposed recommendations require new validation.
