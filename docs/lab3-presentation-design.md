# Lab 3 presentation redesign

The editable deck is `output/lab3/Power9_Lab3_Designer.pptx`; `Power9_Lab3_Slides.pdf` is the PowerPoint-exported reading copy. It replaces the earlier text-only slide layout. The user explicitly deferred video until the app's UI/UX direction is settled.

The composition uses Power9 blue, dark navy and a warm paper background, with large Arial headings and separate layouts for product screenshots, architecture, service evidence, tables and results. Original brand artwork and screenshots retain their proportions. No generated Console or future app mockup is presented as evidence.

There are 15 slides. Auth, Firestore, FCM, Analytics, Crashlytics, Remote Config and Storage each have a service slide. Tables, architecture nodes/connectors and the ARTEMIS chart remain native editable objects. The chart has an embedded workbook snapshot of the published run-ID summary: 30 verified out of 33, including one audit. The workbook snapshot preserves those values; it is not a live link to the JSON source.

Each slide has speaker notes with evidence references and material limits, including image dates, incomplete Analytics/Pro/Storage coverage and the actual PR/fix commits. Updating a screenshot after a UI change does not establish that the new UI has passed the earlier tests.

## Rebuild

Use the bundled `@oai/artifact-tool` runtime. `scripts/lab3/build_designer_deck.mjs` authors the PPTX and runs package/layout/font/native-evidence validation. Set `RUNTIME_NODE_MODULES`, `RUNTIME_PYTHON` and `POWER9_PRESENTATION_SKILL` if the runtime is elsewhere. The finalizer requires a new destination filename for a revision; preserve the old deck until the new one passes validation.

`scripts/lab3/export_designer_deck.ps1` opens the final deck in local PowerPoint without a visible presentation window and exports PDF plus private PNG previews. The 15 final slides were opened/exported in PowerPoint and visually inspected. No Google Slides compatibility test is claimed.

`scripts/lab3/build_submission_pdfs.py` now rebuilds the report only by default, so it cannot silently overwrite the redesigned slides. The old slide generator requires the explicit `--legacy-slides` flag.
