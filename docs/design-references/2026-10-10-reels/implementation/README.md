# RunConvert UI polish

Implemented locally October 10, 2026 after Adriel approved proceeding from the design exploration. No commit, push, App Store upload, version bump, release, physical-device install, or RunSignals change.

[Visual review](review.md) · [Verification record](verification.json) · [Original design reference](</Users/adrielsolorzano/Documents/Personal OS/09_Tools_Workflows/App References/app-ui-design-reference.md>)

## Changes

- Accessibility text sizes stack field/unit controls and Convert/Clear actions. Native primary/secondary button styles remain.
- Results use `ViewThatFits` to reflow values and units instead of reducing the chosen font size. Range separators gain spaces and an en dash so wrapping happens between complete values. Raw conversion results and placeholders remain unchanged.
- Time's distance presets use two columns at standard sizes and one at accessibility sizes. Unit controls and presets have at least 44-point layout height.
- Normal Run pace units are informational labels because its distance picker determines the unit. The former enabled buttons called an action that immediately returned.
- A small RunConvert mark and wordmark appear above the Pace card. The 0.35-second reveal runs once per root view lifetime. The calculator remains visible and interactive throughout; Reduce Motion displays the wordmark immediately. Existing light/dark icon pixels are reused in a named image set.
- Shared numeric fields use unique focus identifiers. Done appears in an inset above the keyboard, clearing the same focus owner. This fixes the iOS 27 floating-toolbar accessibility mismatch reproduced during large-text testing.

Conversion formulas, keyboard types, offline behavior, and the four tabs are preserved. Existing unrelated working-tree changes were left in place.

## Evidence

| Check | Result |
| --- | --- |
| iPhone 17, iOS 27.0, full suite | 15 passed, 0 failures, 0 warnings, before the final range-spacing and informational-unit refinements |
| iPhone 17e, iOS 26.5, final source, full suite | 15 passed, 0 failures, 0 warnings |
| iPhone 17, iOS 27.0, final source | Build and launch passed; normal appearance and opening frames inspected |
| Largest accessibility text | Pace range conversion/Clear, Time estimate, Workout summary, and keyboard dismissal passed on both test runs |
| Background return and tab changes | Entered pace and converted result persisted; test passed |
| Reduce Motion runtime | LLDB read `UIAccessibilityIsReduceMotionEnabled()` as `NO`, then `YES`; original preference `0` restored and debugger detached |
| Mathematical regressions | All seven existing feature tests passed, including rounding, shorthand parsing, extreme inputs, and interval totals |
| Local diff | `git diff --check` passed |

Result bundles are retained locally at `/tmp/runconvert-ui-polish-final-tests.xcresult` and `/tmp/runconvert-ui-polish-small-final-tests.xcresult`. Named captures from the final iPhone 17e run are saved here. The final normal launch recording was visually sampled; its configured animation duration is not a measured app startup time. The preliminary recordings are diagnostic captures, not benchmarks.

The initial large-text button layout reproduced letter-by-letter wrapping. During keyboard diagnosis, the floating Done button's accessibility frame was `(165.67, 798, 71, 36)` while its visible control was elsewhere above the keyboard. Moving Done into app content eliminated the warning and made the keyboard-dismissal checks pass. A matching invalid-dimension warning also appears in the pre-change October 9 test log; this was not merely a new layout assertion failure.

## Files changed in this implementation

- [Feature UI](</Users/adrielsolorzano/Documents/Codex Projects/ios convertor running distances/RunningAppConverterPackage/Sources/RunningAppConverterFeature/ContentView.swift>)
- [UI tests](</Users/adrielsolorzano/Documents/Codex Projects/ios convertor running distances/RunningAppConverterUITests/RunningAppConverterUITests.swift>)
- [RunConvert mark image set](</Users/adrielsolorzano/Documents/Codex Projects/ios convertor running distances/RunningAppConverter/Assets.xcassets/RunConvertMark.imageset/Contents.json>)
- This evidence folder and the shared reference's implementation links.

## Remaining boundaries

Simulator proof does not establish physical-device behavior. The next release step is an iPhone review, followed by an explicitly authorized version/release workflow. App Store localization remains a separate RunConvert distribution experiment. The shared UI skill remains a draft; it has been exercised for this app but is not installed or independently forward-tested. RunSignals can reuse the reference after its own source and rendered-screen review; this batch's localization topic stays excluded from its scope.
