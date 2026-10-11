# RunConvert 1.0.2, build 3

October 11, 2026. Owner authorized physical iPhone checks followed by a GitHub main push and a new App Store Connect build. Later authorization added updated light/dark screenshot graphics. App Store review submission and public release are separate stages.

Bundle com.aisolo.runconvert, team GQF7RG5Z88, App Store record 6816769371 are unchanged. Version 1.0.1 (2) was independently read back Ready for Distribution. TestFlight inventory had build 2 as the latest upload before this update.

## Verified preparation

- All four tabs and submodes tested in both units through iPhone Mirroring: [51 passed normal-size mode checkpoints](../ux-audit-2026-10-10/physical-iphone.md). Largest-text phone test was stopped at the owner's request; Simulator proof remains passed. Phone Settings were never changed and normal app text was restored.
- Release configuration 1.0.2 (3) built with zero warnings/errors, installed and launched on the physical iPhone, then smoke-tested. Built Info.plist confirms bundle/version/build, iOS minimum 17.0, iPhone-only and non-exempt encryption false.
- Previous Simulator audit passed all targeted methods across full/focused runs; the narrower iOS 26.5 run passed 15/15. Two new media capture runs each passed 1/1 with zero failures/warnings.
- Ten new screenshots contain unchanged real app UI. [Media and hashes](1.0.2-media/README.md).
- App Store Connect version 1.0.2 was created as Prepare for Submission, and updated release notes/review instructions were saved. Existing contact, pricing, ratings and release preferences were preserved.

## Distribution stage

Xcode Organizer created the iOS archive at 9:16 AM EDT and confirmed upload at 9:21 AM EDT. Built archive and exported IPA independently confirm 1.0.2 (3), com.aisolo.runconvert, arm64/iphoneos27.0, and valid codesigning. Distribution entitlements have get-task-allow=false; version/build management was disabled so build 3 was preserved.

Apple processing completed. [Build 3](https://appstoreconnect.apple.com/teams/699b640b-05de-4a3a-9ea8-b324ca54c8c7/apps/6816769371/testflight/ios/5079ce59-3a39-487a-842d-6e78c524abc9) was independently read back **Ready to Submit**, then selected and saved on [version 1.0.2](https://appstoreconnect.apple.com/apps/6816769371/distribution/ios/version/inflight). Reload confirmed the selected build persisted. At the initial upload checkpoint the version was Prepare for Submission. The later App Review submission is recorded below; public release remains pending Apple approval.

Ten new screenshot designs were uploaded at both medium (1206 x 2622) and large (1320 x 2868) sizes, 20 assets total. Each slot independently shows 10/10 in the order Pace light, Time dark, Distance light, Normal Run dark, Intervals light, then the alternate theme for each. Older screenshots were detached from this draft's large slot; Apple's confirmation stated they remain in Asset Library. [Provider IDs and file hashes](1.0.2-media/asset-manifest.json) preserve exact identities. These assets are included in the submitted app version; approval/publication remains pending.

Verified source and media were committed and pushed to GitHub main as 92c50b3. Final project records and large-size exports were also promoted to main. Xcode automatically aligned four shared-scheme BuildableName references with RunConvert.app/RunConvert.xctest; target IDs and scheme actions were unchanged.

## App Review submitted October 11 at 9:38 AM EDT

The owner explicitly clarified that the goal is a live App Store update and authorized App Review submission and live distribution. Automatic release after approval and immediate updates to all users were read back selected before submission. No TestFlight tester distribution was configured.

Version 1.0.2 (3) was added to a new app-version draft and formally submitted. Apple confirmed 1 Item Submitted. The [submission detail](https://appstoreconnect.apple.com/apps/6816769371/distribution/reviewsubmissions/details/ad145ae0-adf2-46c0-8772-454c107c6140) independently shows **Waiting for Review**, item iOS App 1.0.2 (3), type App Version, submitted October 11, 2026 at 9:38 AM. Submission ID ad145ae0-adf2-46c0-8772-454c107c6140.

The existing PPO was independently read back Waiting for Review before this submission. Its marketing submission was kept separate and unchanged. Do not interpret a later PPO result without accounting for the new default screenshots.

Next actor: Apple reviews the app update. Approval should trigger the configured automatic public release; public availability has not yet been observed. No monitoring automation was requested or created. Screenshot and review-state proof is retained outside Git in the release-artifact directory.

## Recoverable artifacts

Outside Git: Library/Developer/RunConvertReleases/2026-10-11-1.0.2-build-3/. Physical computer-use captures, launch readbacks and distribution artifacts belong there. No signing secrets, archives, IPAs or Xcode user data belong in Git.
