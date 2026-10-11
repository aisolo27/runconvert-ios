# RunConvert: first App Store release

Current update evidence: [1.0.1 build 2, October 10](release-1.0.1-2026-10-10.md). This guide retains the original 1.0 setup.

Prepared September 27, 2026. The initial guide has now been followed through App Store preparation. See [release progress](release-progress-2026-09-27.md) for verified current status and remaining steps. Do not recreate existing records.

You can skip TestFlight testing. The route is Xcode archive → upload to App Store Connect → select the processed build on the App Store version → App Review → release. An uploaded build may appear under TestFlight even when you never invite testers or start a beta.

## 1. Understand the names before creating anything

| Field | Value in this project | What it means |
| --- | --- | --- |
| Home-screen name | RunConvert | What appears under the installed icon |
| Bundle name | RunConvert | Name in the built app's metadata |
| App Store name | RunConvert | Created in App Store Connect |
| Bundle ID | com.aisolo.runconvert | Permanent app identity after the first uploaded build |
| Version | 1.0 | Public release version |
| Build | 1 | Numeric revision of that version, increment for subsequent uploads |
| Project / target / scheme | RunningAppConverter | Internal Xcode names, safe to leave as-is |
| SKU | runconvert-ios | Internal App Store Connect tracking label, permanent after app creation |
| Apple ID | 6816769371 | Numeric App Store record ID, not your bundle ID or build number |

The build number does not need to be the app's name. Keep it numeric. The store name and home-screen name can change in later releases; the bundle ID cannot change after the first upload. The SKU also cannot change after app creation. A descriptive identifier in Apple Developer is another label, separate from the actual bundle ID.

Adriel chose the `aisolo` prefix on September 27, 2026, so the proposed long-term ID is `com.aisolo.runconvert`. The local project now uses it. The identifier is registered under GQF7RG5Z88 and the RunConvert app record exists in App Store Connect.

Source: [Apple's field definitions](https://developer.apple.com/help/app-store-connect/reference/app-information/app-information).

## 2. Finish the public pages first

You need a public HTTPS privacy policy URL and a working support URL, even for this offline app. A marketing URL is optional. You can put these on an existing website; a separate domain is not required.

Choose the website and public support email first. Local policy text is in [privacy-policy-draft.md](privacy-policy-draft.md). Host that text as a public web page with the real support contact. Create a support page using [support-page-draft.md](support-page-draft.md). Open both pages while signed out and confirm they work on a phone without requiring a login.

The app now includes the offline policy under the hand icon, labelled Privacy Policy, in the navigation bar on all four tabs. Before archiving for submission, add the real public policy link to that screen and verify it opens. The public policy is https://runconvert.vercel.app/privacy and support is https://runconvert.vercel.app/support. Both are linked inside the app. Do not upload a placeholder URL or reuse RunSignal's policy without adapting it to this app.

No networking, analytics, advertising, account system, HealthKit access, or third-party runtime dependencies were found. Inputs live in memory; there is no saved workout history. The policy should describe this behavior, not RunSignal's HealthKit behavior.

Sources: [Privacy requirements, guideline 5.1.1](https://developer.apple.com/app-store/review/guidelines/), [App Privacy](https://developer.apple.com/help/app-store-connect/manage-app-information/manage-app-privacy).

## 3. Check Xcode yourself

1. Open `RunningAppConverter.xcworkspace`.
2. Select the blue project, then the **RunningAppConverter** app target.
3. Under **General**, confirm display name RunConvert, version 1.0, build 1, and iPhone deployment target iOS 17.0.
4. Under **Signing & Capabilities**, confirm your intended paid developer team and bundle ID `com.aisolo.runconvert`. The configured team is `GQF7RG5Z88`; verify the account label yourself.
5. Keep the scheme **RunningAppConverter** selected.
6. Run it on your iPhone. Check Pace, Distance, Time, and Workout, both units, decimal distances, ranges, clear buttons, repeat blocks, deletion of steps/blocks, and the privacy screen. Try it in airplane mode too.

The app is configured for iPhone only. It has 1024 × 1024 light, dark, and tinted icon assets with no alpha channel. No new privacy permissions are needed for its current features. A separate privacy manifest is not automatically required just because an app is being submitted: recheck that if you add SDKs or required-reason APIs.

If Xcode shows an internal RunningAppConverter name in the scheme or archive list, that alone is not a store-name error. Check the app's metadata and App Store Connect fields instead.

## 4. Register the identifier only if it is missing

1. Sign in at [Apple Developer](https://developer.apple.com/account/).
2. Open **Certificates, Identifiers & Profiles → Identifiers**.
3. Search for `com.aisolo.runconvert`.
4. If it exists under the correct team, reuse it.
5. If it is missing, click **+ → App IDs → App**.
6. Description: RunConvert. Choose **Explicit** and enter `com.aisolo.runconvert`.
7. Leave extra capabilities unchecked. This app does not need HealthKit, iCloud, push notifications, or Sign in with Apple.
8. Review the exact identifier, then register it.

## 5. Create or reuse the App Store Connect record

1. Go to [App Store Connect](https://appstoreconnect.apple.com/).
2. Click **Apps**. Check whether RunConvert already exists before creating a duplicate.
3. If it is new: **+ → New App**.
4. Platform: **iOS**.
5. Name: **RunConvert**, if available. If taken, choose another listing name; do not change the bundle ID to solve a name conflict.
6. Primary language: **English (U.S.)**, unless you want a different primary language.
7. Bundle ID: select **com.aisolo.runconvert**.
8. SKU: **runconvert-ios**, or your own deliberate internal label.
9. Choose the appropriate user access and click **Create**.

Source: [Add a new app](https://developer.apple.com/help/app-store-connect/create-an-app-record/add-a-new-app).

## 6. Fill in App Information and age rating

Open **App Information** in the app's sidebar.

- Name: RunConvert.
- Suggested subtitle: `Pace, distance & workout math` (28 characters).
- Suggested primary category: **Health & Fitness**, secondary **Utilities** if helpful.
- Content Rights: the reviewed app does not display third-party feeds or media. Check your rights to the icon and any assets before answering the ownership question.
- License Agreement: Apple's standard EULA is available. A custom legal agreement is optional for this utility, not a required new document.
- **Age Rating → Set Up / Edit**: answer from the actual features. Apple calculates the rating; do not pick a rating by guessing.

For this version, there are no ads, public user content, messaging, unrestricted browsing, gambling, purchases, sexual content, violence, profanity, or drug/alcohol content. A privately entered workout label is not a public user-content feed. There is no diagnosis, treatment, medical guidance, or regulated medical-device functionality. For **Health or Wellness Topics**, read the wording: Apple's examples concern self-care, lifestyle, and exercise recommendations. This app converts values you enter and does not prescribe exercise. On that basis, an absent/no answer fits the current code; revisit it if you add training advice. Report any moderation, parental-control, or age-assurance features as absent because they do not exist.

Do not select **Made for Kids** just because the app is safe for younger users. RunConvert is a general running utility, not an app specifically designed for children. Made for Kids is a separate commitment with additional rules and becomes permanent after approval.

Sources: [Set an age rating](https://developer.apple.com/help/app-store-connect/manage-app-information/set-an-app-age-rating/), [Question definitions](https://developer.apple.com/help/app-store-connect/reference/app-information/age-ratings-values-and-definitions), [Made for Kids definition](https://developer.apple.com/help/app-store-connect/reference/app-information/app-information).

## 7. Fill in App Privacy

1. Click **App Privacy**.
2. Enter the real public **Privacy Policy URL** and save.
3. Click **Get Started**.
4. For the reviewed version, select **No, we do not collect data from this app**.
5. Save, review, and click **Publish** for the privacy answers when shown. Publishing this disclosure does not itself release the app.

Entering pace, distance, time, or workouts locally is not the same as collecting that data on a server. If you add analytics, ads, login, crash-reporting SDKs, or uploads later, revisit this answer.

Source: [Apple's App Privacy steps](https://developer.apple.com/help/app-store-connect/manage-app-information/manage-app-privacy).

## 8. Choose price, availability, and account declarations

1. Open **Pricing and Availability**.
2. Choose your price deliberately. Free has not been selected for you. If paid, finish the required agreements, tax, and banking setup in **Business**.
3. Select the countries/regions you want to distribute in.
4. Complete any account agreement prompts yourself.
5. If distributing in the EU, complete the requested Digital Services Act trader declaration based on your real status. Do not guess that you are or are not a trader merely because the app is free or small.

## 9. Prepare real screenshots and listing text

1. Select **iOS App 1.0** in the sidebar.
2. Upload screenshots showing the real app. Suggested set: converted pace, converted distance, a finish-time estimate or target pace, and an interval workout summary.
3. Use an **iPhone 17 Pro Max** simulator for 1320 × 2868 portrait screenshots accepted in the 6.9-inch section. Hide the keyboard and show useful values. Confirm accepted sizes in the upload area in case Apple changes requirements.
4. Keep screenshots free of personal details. An app preview video is optional.
5. Add description, keywords, and support URL. Marketing URL is optional.
6. Copyright: enter **2026 Adriel Solorzano** if you own the app, or the actual legal owner if different. This field asks for the owner/year, not a copyright registration certificate. Confirm that you own or can use included assets.

Suggested description:

> Convert running pace and distance without having to do the math yourself.
>
> RunConvert converts min/km and min/mi, kilometers and miles, finish times, and target paces. You can also convert a normal run or build an interval workout with warm-up, work, recovery, and cool-down steps.
>
> Everything runs on your phone. No account, ads, or internet connection needed.

Suggested keywords: `running,pace,converter,distance,kilometers,miles,intervals,workout,finish,time`

Sources: [Screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/), [Version fields, including copyright](https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information/).

## 10. Archive and upload in Xcode

Do this after the public policy link is in the app and the iPhone check passes.

1. In Xcode's destination picker, select the generic physical iOS destination, usually **Any iOS Device (arm64)**, rather than a simulator.
2. Click **Product → Archive**. Archiving makes a release artifact locally; it does not publish the app.
3. In Organizer, select the archive and check RunConvert's bundle ID, version 1.0, and build 1.
4. Click **Validate App** if available. Fix validation errors before uploading.
5. Click **Distribute App → App Store Connect → Upload**, following the labels in your Xcode version.
6. Use your intended developer team and automatic signing if appropriate.
7. Review any **Manage Version and Build Number** option. If Xcode manages it, note the actual uploaded number because it may differ from 1. For a replacement upload, increment the build in the project instead of reusing the same number.
8. Review the summary and click **Upload** yourself.
9. Wait for upload success. In App Store Connect, wait for the exact build to finish processing.

The project now declares `ITSAppUsesNonExemptEncryption = NO` because it has no encryption functionality or networking. If a compliance prompt still appears, answer for this exact build; revisit the declaration if its features change.

Seeing the uploaded build under TestFlight does not require starting a beta. Do not create tester groups or invite testers if you want to skip TestFlight.

Source: [Upload builds](https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds).

## 11. Attach the build and submit for review

1. Return to **Apps → RunConvert → iOS App 1.0**.
2. In **Build**, click **+ / Select a build** and select the processed version/build you uploaded.
3. Complete **App Review Information** with your real contact name, email, and phone. These are review contacts, separate from the public support page.
4. Leave **Sign-in required** off because the app has no login.
5. Add notes explaining how to test it. Suggested notes:

> RunConvert is an offline running calculator with four tabs: Pace, Distance, Time, and Workout. No account or special hardware is needed. In Distance, enter 10 kilometers and tap Convert to get 6.21 miles. In Time, 10 kilometers at 5:00/km gives 50:00. Workout supports normal runs and repeat blocks with warm-up, work, recovery, and cool-down. The Privacy Policy button is available in the navigation bar on every tab.

6. In **App Store Version Release**, choose **Manually release this version** if you want to decide when it becomes available after approval.
7. Click **Save**, then **Add for Review**.
8. Open **Draft Submissions / App Review**, review the selected version, and click **Submit for Review**.
9. Follow the real status shown by Apple. If there is a rejection, read the exact message and fix what it identifies.

Source: [Submit an app](https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/submit-an-app).

### If Apple rejects the submission

Read the full message and distinguish an information request, metadata/access correction, and binary defect. Supply every requested item; save matching Review Notes when requested and verify the sent attachments. Reuse the existing build when no code correction is needed.

Check the actual submission and item status after replying. Reply delivery does not prove the app returned to the queue. If the item remains Rejected/Unresolved Issues and is ready for another review, use the authorized **Update Review/Add for Review → Resubmit to App Review** workflow and verify **Waiting for Review** or **In Review**. A disabled Resubmit button may require updating the rejected item first. Stop and report concrete validation errors rather than clicking repeatedly. Follow any explicit Apple instruction to wait; do not withdraw an already queued submission to prompt a response.

For the September 2026 case, see the [current checklist](review-response-2026-09-28/checklist.md) and [dated outcomes](review-response-2026-09-28/lessons-and-outcomes.md). Version 1.0 build 1 was formally resubmitted September 30 at 7:02 PM EDT and automatic release after approval was selected. These are dated observations; reopen App Store Connect before the next action.

Source: [Manage unresolved issues](https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/manage-a-submission-with-unresolved-issues/).

Apple still reviews a small calculator app. Approval is not guaranteed. In particular, guideline 4.2 evaluates usefulness and minimum functionality. Show the actual pace ranges, target pace, and interval conversion features clearly rather than describing it as a single basic converter.

## 12. Release after approval

If you chose manual release, open the approved version and use **Release This Version** when you want it available. Verify the actual public App Store product page in an intended country afterward. Approval, release processing, and public availability are different states.

## Original release checklist (see progress for completed items)

- Choose and publish the support/privacy pages with a real support contact.
- Put the public privacy link in the app and verify it before the final archive.
- Confirm the long-term bundle ID, store-name availability, correct paid team, and existing Apple record.
- Choose price and distribution regions; complete account declarations where applicable.
- Check the app on your iPhone and capture real listing screenshots.
- Archive, validate, upload, submit, and release yourself using this guide.

## Local review and verification

Reviewed the app shell, both original feature files, package dependencies, tests, signing settings, icon assets, and test plan. The runtime feature package has no external dependencies. Core conversion constants and normal running results remain aligned with the existing tests.

Local changes: version 1.0; bundle name RunConvert; export-compliance declaration; accessible offline privacy screen; numeric overflow guards; old output clears when inputs change; keyboard-layout height is bounded to zero or greater. Regression tests cover extreme inputs and the privacy/output UI behavior.

Verification: 11 simulator tests passed, zero failures or skips (7 conversion tests and 4 UI tests) before the bundle ID choice. After changing the ID, a Release build installed and launched on the iPhone 17 simulator. Its Info.plist confirms RunConvert for display and bundle names, bundle ID com.aisolo.runconvert, version 1.0, build 1, iOS minimum 17.0, iPhone device family, and non-exempt encryption false. The changed ID has not been installed or launched on a physical iPhone. `git diff --check` passed.

Two UI tests still emit an invalid-frame warning while the numeric keyboard opens, despite passing. Bounding the converter's geometry height did not eliminate the warning; its source is not yet established. Include numeric keyboard behavior in the physical iPhone check. This is an unresolved layout diagnostic, not a test failure.

Physical-device installation, distribution archive validation, uploaded processing, and App Store approval have not been verified. No commit, push, account mutation, upload, submission, or public publication was performed.
