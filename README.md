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
