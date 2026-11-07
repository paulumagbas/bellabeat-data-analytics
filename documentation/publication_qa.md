# Publication quality assurance

Reviewed November 7, 2026. Local dashboard interaction, package reopening and
native image checks are complete. Provenance limits and hosted-view/link checks
remain. No repository or dashboard was published during this review.

## Completed checks

- Independently recalculated from preserved local raw CSVs: activity 940 rows/33
  IDs; sleep 413 raw rows/410 distinct rows/24 IDs; unique normalized daily keys;
  all sleep keys match activity.
- Verified participant summary exports, all seven same-participant weekday
  export rows, and matched activity-sleep export against raw-record calculations.
- Verified quartiles with an explicit inclusive interpolation implementation,
  statistics.median and statistics.quantiles(method='inclusive'). Step quartiles:
  5566.870967741936 / 7282.966666666666 / 9519.666666666668; IQR
  3952.795698924732. Sleep participant-mean quartiles also match published values.
  These are exact interpolated sample quantiles; only displayed values are rounded.
- Reproduced all three reported correlation coefficients. No numerical result
  was replaced with a different estimator.
- Preserved baseline/same-participant weekday SQL in sql/10_weekday_activity.sql
  and source export queries in sql/11_tableau_summary_exports.sql.
- Source-count discrepancy remains explicit in report and source assessment:
  source-described thirty users versus observed 33 activity IDs and 24 sleep IDs.
  No unverified explanation was added.
- Relative Markdown link targets checked by scripts/verify_portfolio.py; results
  recorded in reports/qa_results.json. This is not a full external-link or GitHub
  rendering test. No public repository or Tableau URL is fabricated.
- Existing workbook XML parses and all four unique text-source paths resolve
  locally. Four worksheet definitions and one dashboard are present.

## Current Tableau verification

The canonical artifact is visualizations/Bellabeat_Analysis.twbx; the older loose
.twb retains superseded hover settings. The corrected package contains exactly
one scoped Select action, the click-and-clear tooltip and all four source CSVs.
The learner confirmed group emphasis, reset and unaffected neighbouring charts,
then confirmed reopening a copied package with working interactions.

The learner exported visualizations/bellabeat_dashboard.png. The assistant
reviewed the supplied full image: all four charts, 33 participant rows, seven
weekday bars, reference line, coverage legend, sensitivity note and source footer
are present, with no active selection or tooltip. PNG dimensions independently
verified as 1400x1200. The participant header is abbreviated and row labels are
dense, but this does not omit participant data; larger viewing improves reading.

The updated automated checker inspects the package rather than the obsolete
loose workbook. It confirms embedded dependencies, one scoped Select action,
correct tooltip instructions, PNG size and existing numerical/link checks.

## Historical troubleshooting record (superseded)

The following dated observations describe earlier versions, not open blockers.
Do not repeat the old hover instructions: publication uses Select.

## Saved Tableau action findings (historical)

### Latest verified package: corrected Select interaction

After troubleshooting, the learner confirmed group emphasis, no dimming in the
other three charts, and reset after clicking empty plotting space, then saved.
The assistant inspected the updated .twbx: exactly one action remains,
Highlight recording coverage, on-select with auto-clear=true; source is Activity
and Sleep in the dashboard, target excludes the other three charts. The tooltip
instructs clicking and clearing. All four CSV dependencies are embedded and the
text connections use package-relative Data/ paths. The generated dashboard-wide
action is absent. This supersedes the historical action findings below.
Hover remains unresolved and is not the chosen publication interaction.
Reopening from a separate folder and native full-image export remain pending.

### November 7 update: newer packaged workbook

The learner confirmed that Select-based group highlighting works: clicking blue
or teal emphasizes the whole coverage group; clicking empty plotting space
restores all colours. Hover did not work and is not validated.

The newer visualizations/Bellabeat_Analysis.twbx was inspected without editing.
It includes an internal workbook plus all four source CSVs. The named action
is on-select with auto-clear=true, explicitly uses the dashboard context and
Activity and Sleep as source, and excludes the other three charts from its
target. Its tooltip now correctly instructs clicking and clearing.

A separate Highlight 1 (generated) on-select action still targets the dashboard.
Its actual effect on other charts must be tested before deciding whether to
change it. The older loose .twb remains on-hover with the old tooltip and must
not be mistaken for the current packaged version. Package contents alone do
not prove reopen portability or native export quality. The earlier findings
and hover-specific instructions below describe the superseded inspection;
the intended publication interaction is now Select, not Hover.

The saved visualizations/Bellabeat_Analysis.twb contains:

1. **Highlight recording coverage**: on-hover, auto-clear=true; source and target
   both Activity and Sleep; field Recording Coverage Group. Configuration matches
   the intended scoped hover behaviour. The learner previously reported reset.
2. **Highlight 1 (generated)**: on-select, auto-clear=true; dashboard-level source
   and target Activity and Recording Patterns. This additional action can explain
   fading in unrelated charts and remains in the saved file.

Do not regard configuration inspection as proof of runtime behaviour. Live
inspection found Tableau open, but input calls encountered concurrent user input;
the assistant stopped input without modifying, saving or exporting the workbook.

## Original manual checklist (completed locally; retained as history)

1. Dashboard > Actions: inspect Highlight 1 (generated). Remove only that unintended
   dashboard-wide highlight if no longer wanted. Retain the scoped hover action.
   Save the workbook. No data or participant exclusion is needed.
2. Hover blue/orange/teal points: only the matching coverage group in Activity and
   Sleep should remain emphasized; all 24 underlying marks remain. Other charts
   should retain normal appearance. Move away and verify reset. Click a mark and
   legend entry as well; clear selection and check for unwanted dashboard-wide dimming.
3. Confirm worksheet counts 33 / 7 / 24 / 24. Inspect endpoint/median values,
   axis units, tooltip days and legend text at intended viewing size.
4. File > Save As > Tableau Packaged Workbook (*.twbx), or the equivalent packaged
   export command offered by the installed edition. Save alongside the .twb.
   The current .twb uses absolute local paths and is not a portable package.
5. Reopen the .twbx from another folder and verify no repair-connection prompt,
   all charts/values, and highlighting. The package should include CSV dependencies.
6. Clear all selections/highlights, then use Dashboard > Export Image (where
   available) to export the full dashboard as visualizations/bellabeat_dashboard.png.
   Inspect the entire 1400x1200 output: title, all 33 rows, all seven bars, both
   scatterplots, legend and bottom notes. A screenshot of the editor is not this test.
7. After publishing separately, test Tableau Public as a viewer, including tooltips,
   highlight reset, layout and downloadable workbook if enabled. Add the real URL
   to README and portfolio text only after it exists.

## Remaining provenance/reproduction limits

- Kaggle license was described as CC0 in the brief; current dataset-specific
  license metadata and the exact downloaded Kaggle version remain unverified.
  Confirm the dataset license before redistributing source files publicly.
- Original Zenodo-to-local byte identity and the thirty-versus-33 discrepancy
  remain unresolved; this is disclosed, not a reason to alter observed counts.
- New SQL files preserve previously validated logic but were not freshly executed
  in BigQuery by the assistant. Run them in BigQuery if fresh native-engine
  verification is required; replace project ID for another account.
- A local link check cannot confirm a future GitHub upload contains every linked
  file. Verify links after upload, particularly filenames containing spaces.
- The report discusses the brief's historical Leaf features, not independently
  verified current product availability or functionality.
