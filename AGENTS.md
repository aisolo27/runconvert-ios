# RunConvert Agent Notes

Small SwiftUI iOS app for offline running conversions. Keep this file compact.

## Structure

- Open `RunningAppConverter.xcworkspace`.
- Feature code lives in `RunningAppConverterPackage/Sources/RunningAppConverterFeature/`.
- App shell lives in `RunningAppConverter/` and should stay thin.
- Tests live in `RunningAppConverterPackage/Tests/` and `RunningAppConverterUITests/`.

## Guardrails

- Keep all conversion math offline and local; do not add backend/network dependencies without explicit approval.
- Preserve the four tabs: `Pace`, `Distance`, `Time`, `Workout`.
- Keep formulas aligned with the old web app behavior: pace, distance, target pace, time estimate, and workout summaries.
- Pace/time fields should use `.numberPad`; distance fields should use `.decimalPad` for decimals.
- Do not commit Xcode user data, DerivedData, archives, or signing secrets.

## Verify

- Run simulator tests after meaningful changes: `test_sim` with scheme `RunningAppConverter`.
- For “push/run/install to my iPhone,” use physical-device build/run with `-allowProvisioningUpdates` when signing needs profiles, and state that proof came from the iPhone, not just Simulator.
- For GitHub, commit/push only when explicitly asked.
