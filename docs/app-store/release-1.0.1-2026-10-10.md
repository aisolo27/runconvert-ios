# RunConvert 1.0.1, build 2

October 10, 2026. Adriel explicitly authorized preparing, uploading and submitting this update so the next gate is Apple's review. Existing bundle identity `com.aisolo.runconvert`, team `GQF7RG5Z88`, and App Store record `6816769371` were reused and independently checked.

## Current stage

Archive and distribution export succeeded. Xcode accepted the upload at 12:33 PM EDT; Apple processing completed and build 2 was selected on version 1.0.1. **App version 1.0.1 (2) was submitted at 12:48 PM EDT and independently verified Waiting for Review.** Automatic release after approval, immediate updates and keeping existing ratings remain selected. Approval and public availability have not yet been observed.

- App submission: `f111e46b-f1cf-487c-91f1-b59c9fec4961`, [App Review](https://appstoreconnect.apple.com/apps/6816769371/distribution/reviewsubmissions/details/f111e46b-f1cf-487c-91f1-b59c9fec4961).
- Build ID: `b3892e36-9465-4426-a5d8-20186b61b189`.
- Separate five-item marketing submission: `cfa78cec-e828-4968-95bf-d771e2d158f1`, submitted 12:47 PM EDT, independently verified Waiting for Review. Two graphics, two CPPs and one PPO.

Apple's concurrent-submission limit blocked the initial app submission, and an app version cannot share a submission with the product-page test. The original marketing submissions were removed and all five items consolidated; the app update was then submitted separately. No asset/page/test was deleted. Final queue: two active submissions, six items Waiting for Review, no leftover draft. Exact history and proofs are in the Personal OS record.

The update carries the new App Store name **RunConvert: Pace Calculator**, subtitle, description, promotional text and keywords. The home-screen name remains **RunConvert**. Only version/build settings changed in app source during this continuation: **1.0.1 / 2**. Existing September source and unrelated working-tree changes were preserved. No Git commit or push was requested or performed.

## Verification

- Xcode 27.0 (27A266a), iOS 27.0 SDK, iPhone-only deployment minimum iOS 17.0.
- Release build installed and launched on iPhone 17 Simulator, iOS 27.0.
- 12 regression tests passed, zero failures/skips: seven conversion tests and five UI tests covering tabs, real results, input/result invalidation, numeric keyboard and offline privacy.
- Three existing invalid-frame diagnostics appeared during keyboard tests, matching the original 1.0 release record. Those tests passed. No app-functionality code changed in this update.
- Archive and exported IPA confirm version 1.0.1, build 2, app identity/team/icon and non-exempt encryption false. Distribution codesign verification passed and `get-task-allow` is false.
- Feature package has no external runtime dependencies; reviewed source retains local calculations, no login/payments/tracking/HealthKit. HTTPS marketing, privacy and support pages all returned 200 with RunConvert content.
- Review notes saved and reloaded for build 2. The earlier September recording is explicitly labelled 1.0 build 1 historical evidence. No new physical-device installation or recording of build 2 was performed.
- Inherited screenshot order verified: Pace, Time, Distance, Workout. Automatic release after approval, immediate updates, and keeping existing ratings are selected.

## Recoverable artifacts

Outside Git: `/Users/adrielsolorzano/Library/Developer/RunConvertReleases/2026-10-10-1.0.1-build-2/`.

Contains the archive, signed IPA, source hashes, build/test proof, archive/distribution inspections, export options, review notes and archive/export/upload logs. Build-number management was disabled during export/upload so Apple receives build 2.

Test result: `/Users/adrielsolorzano/Library/Developer/XcodeBuildMCP/workspaces/Personal-OS-af761702d456/result-bundles/test_sim_2026-10-10T16-29-46-790Z_pid52464_f576a5ca.xcresult`.

Marketing submissions and source research remain in [the Personal OS implementation record](</Users/adrielsolorzano/Documents/Personal OS/09_Tools_Workflows/App References/RunConvert/2026-10-10/implementation-plan.md>). Two standalone graphics, one PPO and two CPPs are separate review items; their approval, placement/publication and measured results are distinct from this app-version update.

## Pending Apple outcomes

The app update has no remaining build/upload/submission step. After approval, verify automatic release and the public 1.0.1 name/copy. Header/search asset approval still needs supported placement/crop preview and publication; keep PPO comparisons consistent. Verify CPP availability and actual PPO Running before claiming either is live. No review-monitoring automation was created.

## October 11 follow-up

App Store Connect independently showed 1.0.1 (2) **Ready for Distribution** during preparation of 1.0.2. The October 10 review-state descriptions above are dated historical evidence. A new public-listing fetch was not part of this follow-up. [Next update](release-1.0.2-2026-10-11.md).
