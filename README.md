# RunConvert

Native iOS running converter for pace, distance, finish-time, target-pace, and workout conversions.

## What It Does

- Converts pace between `min/km` and `min/mi`
- Converts distance between kilometers and miles
- Estimates finish time from distance and pace
- Finds required target pace from distance and goal time
- Converts normal runs and interval workouts between units
- Runs fully offline after install

## Project

- Open: `RunningAppConverter.xcworkspace`
- App target: `RunningAppConverter`
- Feature package: `RunningAppConverterPackage`
- Main UI: `RunningAppConverterPackage/Sources/RunningAppConverterFeature/ContentView.swift`
- Conversion logic: `RunningAppConverterPackage/Sources/RunningAppConverterFeature/RunningConversions.swift`

## Checks

Use Xcode or XcodeBuildMCP:

```sh
xcodebuild test \
  -workspace RunningAppConverter.xcworkspace \
  -scheme RunningAppConverter \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

## App Name

Working display name: `RunConvert`.

## App Store release

App Store Connect currently shows `1.0.1 (2)` Ready for Distribution. The local `1.0.2 (3)` update improves duration entry, Done dismissal, range validation and larger-text layouts. [Simulator audit](docs/ux-audit-2026-10-10/README.md) and [physical iPhone checks](docs/ux-audit-2026-10-10/physical-iphone.md) record the proof. [Updated light/dark media](docs/app-store/1.0.2-media/README.md) uses real verified captures. [Release 1.0.2 record](docs/app-store/release-1.0.2-2026-10-11.md) tracks archive, upload and Apple status separately.

The [support/privacy site](https://runconvert.vercel.app) is live and linked in the app. [Prior update](docs/app-store/release-1.0.1-2026-10-10.md), [original release guide](docs/app-store/release-guide.md) and [September history](docs/app-store/release-progress-2026-09-27.md) retain dated evidence.
