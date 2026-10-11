# RunConvert release progress

## Verified identity

- App Store Connect: https://appstoreconnect.apple.com/apps/6816769371/distribution
- Apple ID: 6816769371; listing: RunConvert; SKU: runconvert-ios.
- Bundle: com.aisolo.runconvert, registered under GQF7RG5Z88 on September 27, 2026.
- Local version 1.0, build 1. Release archive, distribution export, and upload succeeded. Apple processing Complete; version 1.0 (1) submitted and Waiting for Review.
- User authorized a free personal utility, its Vercel support/privacy website, and App Store preparation using Computer Use.
- Attribution: aisolo. Individual Apple developer name follows legal account identity.

## Completed

- App record created in Chrome through Computer Use.
- Description, keywords, copyright, review notes, no sign-in, and manual-release setting saved.
- Health & Fitness primary category and subtitle entered.
- No third-party content; age rating 4+ (regional equivalents); not Made for Kids.
- Declared not a regulated medical device.
- Release build installed/launched in iPhone 17 Pro Max simulator (iOS 26.5).
- Debug simulator suite: 12 passed, zero failed/skipped. Release test attempt failed because module lacked enable-testing, then appropriate Debug test run passed.
- Four screenshots at 1320 x 2868 in screenshots/. Captured by testStoreScreenshotsShowRealConversions and visually checked.
- Screenshot examples: 5:00/km to 8:03/mi; 10 km to 6.21 mi; 10 km at 5:00/km to 50:00; 8 km pace-range workout to 4.97 mi.

## Local artifacts

- Static website source: ../../website/. Public email confirmed by the owner.
- Live: https://runconvert.vercel.app (support: /support, privacy: /privacy).
- Production Vercel project runconvert; deployment dpl_429JFYi8WF2nwFzyL35YPYW1Qd1s, READY. Homepage, both pages, CSS, and icon returned unauthenticated HTTP 200; desktop Chrome pages checked.
- Release archive/export currently in /tmp/runconvert-release-20260927/. Distribution IPA get-task-allow is false; team and identity match.
- Test result: /Users/adrielsolorzano/Library/Developer/XcodeBuildMCP/workspaces/ios-convertor-running-distances-1b15190dc9fd/result-bundles/test_sim_2026-09-27T23-23-40-411Z_pid50732_405fe336.xcresult
- Screenshot attachments: /tmp/runconvert-store-attachments/

## Additional live setup completed

- App Privacy published as Data Not Collected, verified public privacy URL saved.
- Free price tier and all 175 countries/regions selected. Availability is on app release.
- User declared non-trader. Account DSA compliance saved and verified Active for 27 regions; Apple reports requirements complete.
- Four native screenshots accepted in 6.9-inch slot; other iPhone sizes reuse them. Current order: Pace, Time, Distance, Workout.
- Private App Review contact provided by the owner, saved and re-read. Do not place the phone number in this repository.
- Support and marketing URLs saved and verified.
- No ratings/reviews before first release. App Review now contains the submitted version listed below.
- App Accessibility inspected; optional badges left undeclared because dedicated feature testing has not been completed.
- Release build installed and launched on physical AIS17PM after owner unlocked it. Computer Use through iPhone Mirroring verified pace conversion (0:50/km to 1:20/mi), offline policy, and both public privacy/support links opening successfully in Safari.

## Final verification and submission state

- Final simulator run after website links completed: 7 unit tests and 5 UI tests passed, zero failures. UI run took 615 seconds due to XCTest animation-idle waits. Result: /Users/adrielsolorzano/Library/Developer/XcodeBuildMCP/workspaces/ios-convertor-running-distances-1b15190dc9fd/result-bundles/test_sim_2026-09-27T23-39-58-643Z_pid50732_68608988.xcresult
- Physical-device launch and privacy/support-link smoke check completed.
- Upload accepted September 27, 2026, 7:47 PM EDT. Log: /tmp/runconvert-release-20260927/upload.log. Apple Build Uploads shows version 1.0 (1), Complete, and Ready to Submit. Build ID: 42d8890b-38f3-438b-b608-3b2ca7e68cf2. Selected for App Store version 1.0.
- Known runtime warnings: invalid frame dimension while keyboard opens in three UI tests. Earlier 12-test suite passed; visual source not established.
- No Git commit or push authorized/performed. Manual App Store release remains selected.

- Final metadata audit found Content Rights had not persisted. Saved No third-party content and verified it after reload.

- App Store validation passed. Version 1.0 (1) added to a draft submission at 7:51 PM EDT, status Ready for Review. Apple shows Item Ready to Submit and an enabled Submit for Review button.
- Owner explicitly approved submission after a final check. Submitted September 27, 2026 at 7:52 PM EDT. Apple confirmed 1 Item Submitted and Waiting for Review for version 1.0 (1).
- Submission ID: b65c3c12-4d75-4f2c-a23a-e97defed00ad. Review: https://appstoreconnect.apple.com/apps/6816769371/distribution/reviewsubmissions/details/b65c3c12-4d75-4f2c-a23a-e97defed00ad
- Manual release remains selected; approval will not automatically publish the app. Next gate is Apple review, then separately authorized public release.
- Final pre-submission check verified selected build identity, all four screenshot files, complete review contact/instructions, and HTTP 200 for homepage/privacy/support. No additional blocker found. Existing simulator keyboard warnings remain documented above.
- No source code changes in this continuation; preserved all existing local changes. No Git commit or push.

## September 28 review follow-up

- Live status is now Rejected. Apple requested additional information under Guideline 2.1 because the developer account has limited review history. The single message requests a physical-device recording on the latest OS plus purpose/audience, setup instructions, external services, regional behavior, and regulated-services/content-rights details.
- Both September 28 Hotmail notification emails refer to this same submission and issue. Apple's information-only guidance does not require a replacement build solely for these details.
- App Review reply saved as a draft, not sent. Matching Notes saved and re-read. Prepared text and requirement checklist are in review-response-2026-09-28/.
- Original recording correctly shows Home Screen, app launch, and all four tabs with conversion results. Connected iPhone is iOS 27.0 and installed app is 1.0 (1). Latest iOS is 27.0.1, released today, so a recording on that version remains pending to meet Apple's exact request.
- Owner subsequently attached the original video to the saved draft and explicitly chose to use the iOS 27.0 recording because 27.0.1 was just released. Removed the replacement-recording promise from the draft and matching Notes. Final send authorization remains pending; Apple's acceptance of the OS version is unverified. Manual release remains selected; no resubmission/public release performed.
- Owner explicitly authorized Send it. Reply sent September 28 at 7:36 PM EDT. Verified Messages (2), all six answers, original MP4 attachment, and normal Reply to App Review control replacing draft controls. Re-read saved Notes after reload. Status remains Rejected/Unresolved Issues until Apple responds; Resubmit to App Review is disabled. No new build, resubmission, or release performed.
- Review procedure and case lessons saved in [review-response-2026-09-28/lessons-and-outcomes.md](review-response-2026-09-28/lessons-and-outcomes.md). The global ios-release-testflight skill now includes a review packet, device evidence inspection, requirement mapping, and outcome logging. Update the case record from Apple's next actual response; OS-version acceptance remains pending.
