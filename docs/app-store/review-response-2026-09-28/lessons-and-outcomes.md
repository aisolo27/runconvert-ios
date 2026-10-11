# RunConvert review lessons and outcome log

## Current case, September 28, 2026

- RunConvert, Apple ID 6816769371, bundle com.aisolo.runconvert, version 1.0 (1).
- Submission b65c3c12-4d75-4f2c-a23a-e97defed00ad: [App Review](https://appstoreconnect.apple.com/apps/6816769371/distribution/reviewsubmissions/details/b65c3c12-4d75-4f2c-a23a-e97defed00ad).
- Apple requested six information items under Guideline 2.1 because of limited developer review history. Its message did not identify a specific crash or calculation bug.
- Reply sent at 7:36 PM EDT with the original MP4 attachment. Sent message, attachment, and matching saved Notes verified. Detailed evidence is in [checklist.md](checklist.md); [reply.txt](reply.txt) and [notes.txt](notes.txt) retain the supplied text.
- Last verified provider state after sending: Rejected/Unresolved Issues, Resubmit to App Review disabled. This is a dated observation, not a current-state guarantee for future sessions.
- Recording shows physical-device launch and the four tabs with outputs. Actual device OS was iOS 27.0. Apple released 27.0.1 the same day; the owner knowingly chose the original recording. Apple's acceptance remains pending. No replacement-recording promise remains in the reply or Notes.
- Manual release is selected. No replacement build, resubmission, or public release was performed for this response.

## Lessons to reuse

1. Prepare purpose/audience, setup/access, services, regional behavior, and regulated/content-rights explanations before submission. Support each claim with the app's actual behavior and configuration.
2. Prepare a physical-device demonstration with launch and meaningful results. Inspect the beginning directly: the initial sparse contact sheet skipped the first seconds and led to an incorrect missing-launch assessment. Full opening inspection confirmed launch was present.
3. Use Focus before recording. The original video included personal notification banners; the owner attached and chose to use it. Avoid that exposure in future recordings.
4. Map every exact Apple request to evidence and remaining work. Account, content, and purchase flows were N/A here; verify applicability afresh for each app.
5. Save matching review Notes, verify persistence, and distinguish a draft with an attachment from a sent response. Re-read the sent message and attachment after submission.
6. Treat a latest-OS gap as unresolved even if the owner proceeds. Do not treat a same-day patch as an established exception or claim all requirements have been accepted.
7. Keep information replies, binary fixes, rejection resolution, approval, and release separate. Follow the actual Apple message and available controls.
8. Do not conclude that waiting is the only next step because Apple requested a reply or Resubmit is disabled. In this case, Update Review prepared the rejected item, enabled Resubmit to App Review, and formal resubmission produced Waiting for Review before Apple replied. Reply sent and saved metadata are evidence of delivery, not queue status. Apply the shared status-based procedure, including explicit wait/investigation exceptions, to each app independently.

The reusable procedure now lives in the global `ios-release-testflight` skill, under `references/review-readiness.md`. App identity, facts, evidence, and outcomes stay here. For RunSignal, evaluate HealthKit access, onboarding, privacy disclosures, permission-denied and empty-data flows against its current build; RunConvert's N/A declarations do not transfer.

## Next Apple response

When this case is resumed, inspect the current submission and append a dated entry below. Do not overwrite the original pending evidence or infer that Apple accepted a disputed detail from silence.

For further rejection, record the exact guideline/request, version/build, remaining evidence gap, remedy, verification, and sent response. Update checklist.md accordingly.

For approval, record the approved version/build, provider status/time, attached recording and packet, and any explicit Apple comment about the OS version. Approval alone does not establish a reusable latest-OS waiver. Confirm release mode and authorization separately before releasing.

### Outcome entries

- September 30, 2026: updated the shared ios-release-testflight workflow, its review-readiness reference, this project's release guide, and the current checklist to distinguish Save, sent correspondence, Ready for Review, Waiting for Review/In Review, approval, and public release. Removed the stale current-work instruction that assumed a disabled resubmit button meant only waiting was needed. Structural skill validation passed; whitespace checks passed. Manually walked through rejected information requests with disabled resubmit, already queued clarification, binary defects, explicit Apple investigation/wait instructions, reply-only authorization, and approved/manual-release cases. The procedure completes authorized resubmission, preserves explicit wait instructions and missing authority, and keeps each app's permissions/data claims separate. These walkthroughs validate procedural decisions, not Apple approval outcomes.

- September 30, 2026, 7:02 PM EDT: owner authorized formal resubmission before Apple's reply. Confirmed the September 28 response and MP4 remain attached. Added the existing video filename and reply date to Review Notes, saved, clicked Update Review, verified Ready for Review and enabled Resubmit to App Review, then resubmitted. App Store Connect confirmed Waiting for Review for version 1.0 build 1, submission b65c3c12-4d75-4f2c-a23a-e97defed00ad, Date Submitted Sep 30, 2026 at 7:02 PM. Automatic release after approval remains configured. No new build or public release. This verifies receipt and queue state, not acceptance of the packet or recording OS version.

- September 28, 2026: response sent; Apple decision pending. No accepted workaround established.
- September 30, 2026, 6:28 PM EDT: owner approved the keyword update and automatic release after approval. Saved and verified after reloading App Store Connect: keywords `running,converter,calculator,kilometers,miles,intervals,finish,time,race,5k,10k,half,marathon,km,mi` (99 characters), and Automatically release this version selected. Name, subtitle, description, and build unchanged. Submission still Rejected/Unresolved Issues; September 28 reply and MP4 are present with no newer Apple response. No Update Review, formal resubmission, or public release performed. The release selection supersedes the dated manual-release observation above.
