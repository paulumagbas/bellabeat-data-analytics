# Supporting scripts

- `verify_portfolio.py`: independent recalculation and file/configuration audit.
  Python 3.10+ standard library only. Obtain the two source CSVs as described in
  the main README before running; the four exported summary CSVs are included.
  Writes `reports/qa_results.json`. Does not execute BigQuery or drive Tableau.
- `assemble_report.py`: rebuilds the main Markdown report from the reviewed
  sections in reports/. Python standard library only; it performs no analysis.
- `plot_activity_sleep.mjs`: optional generator for the diagnostic scatterplot,
  separate from the native Tableau dashboard. Requires Node.js and the `sharp`
  package installed in an environment where Node can resolve it. Run from the
  project root with the participant matched-summary CSV path as its argument.
  Its leave-one-out calculations are diagnostics, not confidence intervals.
- `prepare_github_upload.py`: creates a fresh, curated github-upload/ folder from
  this workspace. Does not publish, move, overwrite or delete original files.

The `.twbx` and native dashboard PNG are the intended visual portfolio artifacts.
The helpers were developed with technical assistance; the learner executed the
GoogleSQL analyses and built the Tableau dashboard through the guided workflow.
