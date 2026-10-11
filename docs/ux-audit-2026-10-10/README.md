# RunConvert keyboard and time-entry audit

Audit begun October 10 and completed October 11, 2026. Local implementation only; no release, commit, push, or physical-device install.

## Recording evidence

Source: [user-provided recording](</Users/adrielsolorzano/Downloads/RPReplay_Final1791678100.MP4>). All 3,245 decoded frames were compared with their predecessors; 564 meaningful frame changes were detected. Visual timeline samples and dense state transitions were inspected. This is not a claim that every frame was separately human-reviewed. Container metadata declares 3,246 frames; FFmpeg decodes 3,245 with corresponding timestamps. [Source hash and observations](recording-analysis.json), [frame changes](frame-change-scan.json).

The recording shows Distance keyboard entry without visible Done around 12–16 seconds, Time entry without visible Done around 20–25 seconds, and `45:72` followed by a generic target-time error around 33–36 seconds. The half-marathon/minute-only interaction appears around 43–48 seconds. The `135` example came from Adriel's explanation; it was not confirmed as a literal entry in the recording. The clip shows the earlier interface, and does not establish the physical device's build number.

## Changes

- Target Time, From Time, To Time, and all timed workout sections use separate **Hours, Minutes, Seconds** numeric fields with `hh`, `mm`, `ss` placeholders. Blank parts count as zero; the input must represent a positive duration.
- A live preview such as `1:35:00 · 1 hr 35 min` confirms interpretation. Entering 25 in Minutes means 25 minutes. Entering 1 in Hours and 35 in Minutes means 95 minutes. Seconds and minutes must be 0–59; 135 in Minutes is rejected with guidance to use Hours.
- Pasted complete clock strings keep their meaning and distribute into components. Malformed text is retained for correction rather than flattened into a different duration.
- Pace fields show `m:ss` and format guidance. A short entry such as 25 confirms `25 min 0 sec`; seconds outside 0–59 and zero pace are rejected.
- Every numeric field uses the same focus owner and visible Done bar. Leaving a tab or removing an editing field clears focus. Standard decimal and number pads remain.
- Reversed distance, pace, and target-time ranges receive specific errors. Pasted negative distances and malformed paces are no longer silently turned into valid positive values.
- The preset now says **Half Marathon**. Interval output explains that its distance total includes distance-based steps, while timed and open steps aren't estimated.

Conversion formulas, unit constants, race-preset distances, output rounding, and the four tabs remain. Interval totals preserve the web behavior of rounding each converted step before multiplying repeats. For example, a 1 km warm-up plus five 400 m steps adds `0.62 + 5 × 0.25 = 1.87 mi`; it intentionally differs from a single final conversion of 3 km. The displayed total agrees with displayed step distances.

## Simulator matrix

The source and [scenario results](scenario-results.json) retain **52 unique passing UI checkpoints**, including the following coverage:

| Surface | Coverage |
| --- | --- |
| Pace | Single/range × km/mi, positive values, zero rejection, reversed-range rejection |
| Distance | Single/range × km/mi, decimals, reversed-range rejection |
| Time Estimator | All four pace/distance combinations × km/mi |
| Target Pace | All four distance/time combinations × km/mi; every hours/minutes/seconds field; empty and reversed-time errors |
| Race presets | Half marathon at 1 hr 35 min and marathon at 4 hr 30 min × km/mi |
| Normal Run | None/single pace/pace range × km/mi |
| Interval distance goals | Meters/kilometers/miles, all effort modes, pace units, km/mi output; pairwise fixtures rather than every possible Cartesian product |
| Interval time goals | Hours/minutes/seconds for warm-up, work, recovery, cool-down × km/mi output |
| Interval open goals | All four section roles × km/mi output |
| Editor actions | Add step, change role, delete step, add/delete repeat block × km/mi |
| Focus and layout | Done availability and hittability, keyboard disappearance after Done, mode removal while editing, largest-text duration entry, background/tab preservation regressions |
| Input validation | Empty/zero, oversized hour values, minute/second overflow, malformed pasted text, complete clocks, negative distance, malformed pace |

The aggregate main-platform validation covers **31 distinct test methods**, all with a passing result after focused reruns. Swift Testing also executes parameterized input cases; method counts and checkpoint counts are separate quantities. Eight existing UI regression methods and seven existing mathematical regression methods remain included.

The first broad run passed 28/31 methods with no runtime warnings. Three test-harness issues were corrected: lazy preset rows needed scrolling before existence assertions; standard text size needed explicit launch isolation; and a unit popup option needed scoping to its collection to avoid a same-named background output button. All three focused reruns passed. The large test exceeded the MCP response window but Xcode continued locally; its `.xcresult` was read independently at completion.

The full primary matrix ran on iPhone 17 / iOS 27.0. Narrow-screen iOS 26.5 validation is recorded separately in the final [verification file](verification.json). [Visual review](review.md) contains selected actual Simulator captures.

## Changed files

- [Feature UI and focus handling](</Users/adrielsolorzano/Documents/Codex Projects/ios convertor running distances/RunningAppConverterPackage/Sources/RunningAppConverterFeature/ContentView.swift>)
- [Duration input model](</Users/adrielsolorzano/Documents/Codex Projects/ios convertor running distances/RunningAppConverterPackage/Sources/RunningAppConverterFeature/DurationEntry.swift>)
- [Strict pasted-input validation and rounding rationale](</Users/adrielsolorzano/Documents/Codex Projects/ios convertor running distances/RunningAppConverterPackage/Sources/RunningAppConverterFeature/RunningConversions.swift>)
- [Input-model tests](</Users/adrielsolorzano/Documents/Codex Projects/ios convertor running distances/RunningAppConverterPackage/Tests/RunningAppConverterFeatureTests/DurationEntryTests.swift>)
- [Simulator audit and regression tests](</Users/adrielsolorzano/Documents/Codex Projects/ios convertor running distances/RunningAppConverterUITests/RunningAppConverterUITests.swift>)

Original footage remains in Downloads. No source media was uploaded externally. Unrelated working-tree changes were preserved. Simulator proof does not establish a physical-device install or App Store release. Pace retains its existing input limit of 59 minutes and 59 seconds; timed/open interval steps do not add estimated distance. This audit covers the recorded behavior and representative mode/unit fixtures, not every conceivable value or sequence.
