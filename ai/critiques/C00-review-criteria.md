# C00 UX critique prompt

Status: DRAFT. Run against actual attached Stitch output, after saving P00 images. Preserve this prompt plus the complete AI response in ai/critiques/. Do not replace the full response with a summary table.

```text
Review the attached actual Power9 Stitch screens as a UX reviewer. First list the screen IDs and versions you can actually see. Do not invent missing screens, interactions, measurements or user-test results.

Context: one Android app, 360×800 base, Vietnamese UI. Primary hypothetical persona Linh, a parent with five minutes: find and add a suitable habit under 60 seconds. Supporting hypothetical personas: Minh direct check-in within three actions, Huy reschedule under 30 seconds, Hùng needs readable labeled controls and confidence recovering from mistakes. These are untested design targets.

Evaluate against Nielsen's ten usability heuristics (name the applicable heuristic), accessibility and these personas. Check F01 add habit; F02 complete/view history, including category alternatives; F03 reschedule. Look for visible feedback, input preservation, Back/cancel, loading, empty, error/retry, undo and destructive confirmation.

Produce at least five concrete findings ONLY when supported by visible evidence. Each finding must contain:
- Finding ID UX01 etc.; actual screen ID and version.
- Specific visible evidence or text; distinguish observation from inference.
- User impact and severity.
- Named Nielsen heuristic and/or accessibility criterion and affected persona.
- A concrete proposed change.
- How to verify the change and which screenshot should be captured.
If fewer than five supported issues exist, say so instead of inventing enough findings.

Contrast must be measured from actual colors before stating a numeric pass/fail. From a screenshot alone, mark tap target dp, font sp, token bindings, Auto Layout and functional navigation “needs inspection” unless actual dimensions/structure are supplied. Do not claim task-time targets are achieved from static images.

Conclude with three DIFFERENT, evidence-supported iteration goals if justified by findings. Do not add deliberate UX defects to force iterations. Do not decide accept/modify/reject on behalf of the student; list recommendations for the group to decide.
```
