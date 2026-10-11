# RunConvert App Review response checklist

Status verified September 30, 2026 at 7:02 PM EDT: version 1.0 build 1 formally resubmitted and Waiting for Review. The September 28 reply and MP4 remain attached. Notes contain the requested information plus the video's filename and reply date. Automatic release after approval is selected. Queue receipt is verified; Apple's acceptance of the packet, recording OS version, and app remain pending.

Historical evidence: response sent September 28, 2026 at 7:36 PM EDT, with matching Notes saved and reloaded. Owner chose the original iOS 27.0 recording after being informed that iOS 27.0.1 was released September 28. Do not describe that choice as Apple's acceptance of a latest-OS exception.

## Live review issue

- App: RunConvert, Apple ID 6816769371, version 1.0 (1).
- Submission: b65c3c12-4d75-4f2c-a23a-e97defed00ad.
- Apple message: Guideline 2.1, Information Needed, New App Submission. One review issue, six requested information items. Generic prevention guidance does not establish additional app-specific defects.
- September 28 Hotmail emails at 7:16:43 PM and 7:16:47 PM EDT both refer to this same review issue. Information-only corrections may be handled by updating metadata and replying, without a new app build.

## Requested items

| Item | Evidence and status |
| --- | --- |
| 1. Physical-device recording on latest OS, beginning with launch and showing typical flow | Original MP4 is 128.278 seconds and shows Home Screen, RunConvert launch, Pace range result, Distance result, Time estimate and target pace, Normal Run result, and interval result. Connected physical iPhone is iOS 27.0, and its installed app is com.aisolo.runconvert 1.0 (1). Apple released iOS 27.0.1 September 28, 2026. Owner chose the original recording; do not claim it uses the latest patch or that Apple has accepted it. The file is attached to the verified sent reply. |
| 2. Purpose, audience, problem, and value | Included in saved Notes and sent reply: free running calculator for runners/coaches converting units and planning time/pace. |
| 3. Setup and main-feature access | Included in saved Notes and sent reply: no setup/sign-in/permissions/sample files; instructions and sample results for all four tabs and Target Pace. |
| 4. External services, tools, platforms | Included: native SwiftUI/Foundation, local calculations, no third-party SDKs or backend. Vercel hosts optional public privacy/support website and is not required for calculations. Verified against feature sources, package manifest, and app shell. |
| 5. Regional differences | Included: consistent feature behavior across available regions, manual km/mi choice, no location-dependent functionality. |
| 6. Regulated industry and protected third-party content | Included: running calculator, no medical/regulated services or protected third-party content requiring credentials. |

## Conditional flows and prevention guidance

- Account registration/login/deletion: not applicable, no account system; saved Sign-in required remains unchecked.
- User-generated content/reporting/blocking: not applicable, no shared-content functionality.
- Paid features/IAP: not applicable, free app and no StoreKit/purchase implementation.
- Supported physical platform: exported app Info.plist UIDeviceFamily is [1] (iPhone only), minimum iOS 17.0. Original recording and installed-app listing prove physical iPhone use; no latest-patch test is claimed.
- Screenshots: live version lists four actual converter screenshots, Pace, Time, Distance, Workout, inherited from 6.9-inch display size.
- Business-only distribution: not applicable, general public running utility.
- No specific bug/crash was identified in Apple's message. No source changes or new build were requested or made in this response preparation.

## Prepared records

- Reply initially saved as an App Store Connect draft. Owner then explicitly authorized Send it. Sent at 7:36 PM EDT, verified as a regular message with the original video attachment.
- Matching App Review Notes saved and updated to accurately state iOS 27.0, without a promise of a replacement recording.
- Original recording has private notification banners. Owner attached the original file to the draft and explicitly opted to use it. The agent did not upload the video.
- September 30: automatic release after approval saved and verified. Update Review changed the item to Ready for Review and enabled Resubmit to App Review; formal resubmission then changed the submission and item to Waiting for Review at 7:02 PM EDT. No public release or replacement build.
- Local reply.txt and notes.txt retain the September 28 prepared text. Live Notes gained an explicit video filename/reply-date reference before September 30 resubmission; see the outcome log.

## Remaining work

1. Await Apple's review decision now that Waiting for Review is confirmed. Apple must decide whether the supplied packet and iOS 27.0 recording satisfy its request.
2. If Apple requests another change, map its exact request to evidence and inspect current submission/item statuses. A new build is needed for a binary correction, not merely because the item says Rejected.
3. Do not equate a sent reply or saved Notes with formal resubmission. For a rejected item ready to be reviewed again, Update Review can prepare the item and enable Resubmit to App Review. Complete the authorized submission and verify Waiting for Review or In Review, unless Apple explicitly directs waiting.
4. Approval and public availability remain separate outcomes. Automatic release is configured; verify the public App Store listing after approval and release processing.

Latest OS reference: https://support.apple.com/en-us/100100 and https://developer.apple.com/news/releases/ (checked September 28, 2026).

## Future review reference

See [Review lessons and outcome log](lessons-and-outcomes.md) before the next response or release. Append Apple's actual decision there and update this checklist from current provider evidence.
