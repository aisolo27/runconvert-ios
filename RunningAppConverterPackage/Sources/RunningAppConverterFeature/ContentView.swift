import SwiftUI

public struct ContentView: View {
    public init() {}

    public var body: some View {
        TabView {
            NavigationStack {
                PaceConverterScreen()
            }
            .tabItem {
                Label("Pace", systemImage: "speedometer")
            }

            NavigationStack {
                DistanceConverterScreen()
            }
            .tabItem {
                Label("Distance", systemImage: "ruler")
            }

            NavigationStack {
                TimeConverterScreen()
            }
            .tabItem {
                Label("Time", systemImage: "timer")
            }

            NavigationStack {
                WorkoutConverterScreen()
            }
            .tabItem {
                Label("Workout", systemImage: "figure.run")
            }
        }
        .tint(.primary)
    }
}

private struct PaceConverterScreen: View {
    @State private var mode: ConversionInputMode = .single
    @State private var selectedUnit: DistanceUnit = .km
    @State private var input = ""
    @State private var rangeStartInput = ""
    @State private var rangeEndInput = ""
    @State private var result: String?
    @State private var error = ""

    var body: some View {
        ConverterScrollView(title: "Pace Converter") {
            ConverterCard {
                SectionHeader(title: "Pace Converter", systemImage: "speedometer")

                Picker("Pace mode", selection: $mode) {
                    Text("Pace").tag(ConversionInputMode.single)
                    Text("Pace Range").tag(ConversionInputMode.range)
                }
                .pickerStyle(.segmented)
                .onChange(of: mode) { _, _ in resetResult() }

                if mode == .single {
                    UnitTextField(
                        label: selectedUnit == .km ? "Input (min/km)" : "Input (min/mi)",
                        placeholder: "7:40",
                        text: $input,
                        unitLabel: selectedUnit.paceLabel,
                        keyboardType: .numbersAndPunctuation,
                        onUnitTap: toggleUnit
                    )
                    .onChange(of: input) { _, value in
                        updatePaceInput(value, binding: $input)
                    }
                } else {
                    VStack(spacing: 10) {
                        UnitTextField(
                            label: selectedUnit == .km ? "Faster (min/km)" : "Faster (min/mi)",
                            placeholder: "6:00",
                            text: $rangeStartInput,
                            unitLabel: selectedUnit.paceLabel,
                            keyboardType: .numbersAndPunctuation,
                            onUnitTap: toggleUnit
                        )
                        .onChange(of: rangeStartInput) { _, value in
                            updatePaceInput(value, binding: $rangeStartInput)
                        }

                        UnitTextField(
                            label: selectedUnit == .km ? "Slower (min/km)" : "Slower (min/mi)",
                            placeholder: "6:30",
                            text: $rangeEndInput,
                            unitLabel: selectedUnit.paceLabel,
                            keyboardType: .numbersAndPunctuation,
                            onUnitTap: toggleUnit
                        )
                        .onChange(of: rangeEndInput) { _, value in
                            updatePaceInput(value, binding: $rangeEndInput)
                        }
                    }
                }

                ConverterOutput(
                    label: selectedUnit == .km ? "Output (min/mi)" : "Output (min/km)",
                    value: result ?? (mode == .range ? "--:-- - --:--" : "--:--"),
                    unit: selectedUnit.opposite.paceLabel
                )

                ActionRow(
                    primaryTitle: "Convert",
                    primarySystemImage: "equal",
                    onPrimary: convert,
                    onClear: clear
                )

                InlineError(error)
            }
        }
    }

    private func updatePaceInput(_ value: String, binding: Binding<String>) {
        let sanitized = RunningConversions.sanitizePaceInput(value)
        if sanitized != value {
            binding.wrappedValue = sanitized
        }
        error = ""
    }

    private func convert() {
        if mode == .range {
            guard let startSeconds = RunningConversions.parseFlexiblePaceToSeconds(rangeStartInput),
                  let endSeconds = RunningConversions.parseFlexiblePaceToSeconds(rangeEndInput)
            else {
                error = "Enter a valid faster and slower pace range."
                return
            }

            let convertedStart = RunningConversions.convertPace(startSeconds, from: selectedUnit, to: selectedUnit.opposite)
            let convertedEnd = RunningConversions.convertPace(endSeconds, from: selectedUnit, to: selectedUnit.opposite)
            result = "\(RunningConversions.formatPace(convertedStart))-\(RunningConversions.formatPace(convertedEnd))"
            error = ""
            return
        }

        guard let seconds = RunningConversions.parseFlexiblePaceToSeconds(input) else {
            error = "Enter a valid pace like 7:40 or 605."
            return
        }

        let converted = RunningConversions.convertPace(seconds, from: selectedUnit, to: selectedUnit.opposite)
        result = RunningConversions.formatPace(converted)
        error = ""
    }

    private func toggleUnit() {
        selectedUnit = selectedUnit.opposite
        resetResult()
    }

    private func resetResult() {
        result = nil
        error = ""
    }

    private func clear() {
        input = ""
        rangeStartInput = ""
        rangeEndInput = ""
        resetResult()
    }
}

private struct DistanceConverterScreen: View {
    @State private var mode: ConversionInputMode = .single
    @State private var selectedUnit: DistanceUnit = .km
    @State private var input = ""
    @State private var rangeStartInput = ""
    @State private var rangeEndInput = ""
    @State private var result: String?
    @State private var error = ""

    var body: some View {
        ConverterScrollView(title: "Distance Converter") {
            ConverterCard {
                SectionHeader(title: "Distance Converter", systemImage: "ruler")

                Picker("Distance mode", selection: $mode) {
                    Text("Distance").tag(ConversionInputMode.single)
                    Text("Range").tag(ConversionInputMode.range)
                }
                .pickerStyle(.segmented)
                .onChange(of: mode) { _, _ in resetResult() }

                if mode == .single {
                    UnitTextField(
                        label: selectedUnit == .km ? "Input (km)" : "Input (mi)",
                        placeholder: "10",
                        text: $input,
                        unitLabel: selectedUnit.shortLabel,
                        keyboardType: .decimalPad,
                        onUnitTap: toggleUnit
                    )
                    .onChange(of: input) { _, value in
                        updateDecimalInput(value, binding: $input)
                    }
                } else {
                    VStack(spacing: 10) {
                        UnitTextField(
                            label: selectedUnit == .km ? "From (km)" : "From (mi)",
                            placeholder: "From",
                            text: $rangeStartInput,
                            unitLabel: selectedUnit.shortLabel,
                            keyboardType: .decimalPad,
                            onUnitTap: toggleUnit
                        )
                        .onChange(of: rangeStartInput) { _, value in
                            updateDecimalInput(value, binding: $rangeStartInput)
                        }

                        UnitTextField(
                            label: selectedUnit == .km ? "To (km)" : "To (mi)",
                            placeholder: "To",
                            text: $rangeEndInput,
                            unitLabel: selectedUnit.shortLabel,
                            keyboardType: .decimalPad,
                            onUnitTap: toggleUnit
                        )
                        .onChange(of: rangeEndInput) { _, value in
                            updateDecimalInput(value, binding: $rangeEndInput)
                        }
                    }
                }

                ConverterOutput(
                    label: selectedUnit == .km ? "Output (mi)" : "Output (km)",
                    value: result ?? (mode == .range ? "--.-- - --.--" : "--.--"),
                    unit: selectedUnit.opposite.shortLabel
                )

                ActionRow(
                    primaryTitle: "Convert",
                    primarySystemImage: "equal",
                    onPrimary: convert,
                    onClear: clear
                )

                InlineError(error)
            }
        }
    }

    private func updateDecimalInput(_ value: String, binding: Binding<String>) {
        let cleaned = RunningConversions.cleanDecimalInput(value)
        if cleaned != value {
            binding.wrappedValue = cleaned
        }
        error = ""
    }

    private func convert() {
        if mode == .range {
            guard let start = RunningConversions.parseDistance(rangeStartInput),
                  let end = RunningConversions.parseDistance(rangeEndInput)
            else {
                error = "Enter a valid distance range."
                return
            }

            let convertedStart = RunningConversions.convertDistance(start, from: selectedUnit, to: selectedUnit.opposite)
            let convertedEnd = RunningConversions.convertDistance(end, from: selectedUnit, to: selectedUnit.opposite)
            result = "\(RunningConversions.formatDistance(convertedStart))-\(RunningConversions.formatDistance(convertedEnd))"
            error = ""
            return
        }

        guard let distance = RunningConversions.parseDistance(input) else {
            error = "Enter a valid distance."
            return
        }

        result = RunningConversions.formatDistance(RunningConversions.convertDistance(distance, from: selectedUnit, to: selectedUnit.opposite))
        error = ""
    }

    private func toggleUnit() {
        selectedUnit = selectedUnit.opposite
        resetResult()
    }

    private func resetResult() {
        result = nil
        error = ""
    }

    private func clear() {
        input = ""
        rangeStartInput = ""
        rangeEndInput = ""
        resetResult()
    }
}

private struct TimeConverterScreen: View {
    private let presets = [
        TargetDistancePreset(label: "5K", km: "5", mi: "3.1"),
        TargetDistancePreset(label: "10K", km: "10", mi: "6.2"),
        TargetDistancePreset(label: "Half", km: "21.1", mi: "13.1"),
        TargetDistancePreset(label: "Marathon", km: "42.2", mi: "26.2")
    ]

    @State private var selectedUnit: DistanceUnit = .km
    @State private var paceMode: ConversionInputMode = .single
    @State private var distanceMode: ConversionInputMode = .single
    @State private var distanceInput = ""
    @State private var distanceFromInput = ""
    @State private var distanceToInput = ""
    @State private var paceInput = ""
    @State private var fasterPaceInput = ""
    @State private var slowerPaceInput = ""
    @State private var estimateResult: String?
    @State private var estimateError = ""

    @State private var targetDistanceMode: ConversionInputMode = .single
    @State private var targetTimeMode: ConversionInputMode = .single
    @State private var targetDistanceInput = ""
    @State private var targetDistanceFromInput = ""
    @State private var targetDistanceToInput = ""
    @State private var targetTimeInput = ""
    @State private var targetTimeFromInput = ""
    @State private var targetTimeToInput = ""
    @State private var targetResult: String?
    @State private var targetError = ""

    var body: some View {
        ConverterScrollView(title: "Time Converter") {
            ConverterCard {
                SectionHeader(title: "Time Estimator", systemImage: "timer")

                Picker("Pace estimate mode", selection: $paceMode) {
                    Text("Pace").tag(ConversionInputMode.single)
                    Text("Pace Range").tag(ConversionInputMode.range)
                }
                .pickerStyle(.segmented)
                .onChange(of: paceMode) { _, _ in resetEstimate() }

                Picker("Distance estimate mode", selection: $distanceMode) {
                    Text("Distance").tag(ConversionInputMode.single)
                    Text("Range").tag(ConversionInputMode.range)
                }
                .pickerStyle(.segmented)
                .onChange(of: distanceMode) { _, _ in resetEstimate() }

                timeEstimateInputs

                ConverterOutput(
                    label: "Estimated Finish",
                    value: estimateResult ?? (distanceMode == .range || paceMode == .range ? "--:-- - --:--" : "--:--"),
                    unit: ""
                )

                ActionRow(
                    primaryTitle: "Estimate",
                    primarySystemImage: "timer",
                    onPrimary: estimateTime,
                    onClear: clearEstimate
                )

                InlineError(estimateError)
            }

            ConverterCard {
                SectionHeader(title: "Target Pace", systemImage: "scope")

                HStack(spacing: 8) {
                    ForEach(presets) { preset in
                        Button {
                            targetDistanceMode = .single
                            targetDistanceInput = preset.value(for: selectedUnit)
                            targetDistanceFromInput = ""
                            targetDistanceToInput = ""
                            resetTarget()
                        } label: {
                            Text(preset.label)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                    }
                }

                Picker("Target distance mode", selection: $targetDistanceMode) {
                    Text("Distance").tag(ConversionInputMode.single)
                    Text("Range").tag(ConversionInputMode.range)
                }
                .pickerStyle(.segmented)
                .onChange(of: targetDistanceMode) { _, _ in resetTarget() }

                Picker("Target time mode", selection: $targetTimeMode) {
                    Text("Time").tag(ConversionInputMode.single)
                    Text("Range").tag(ConversionInputMode.range)
                }
                .pickerStyle(.segmented)
                .onChange(of: targetTimeMode) { _, _ in resetTarget() }

                targetPaceInputs

                ConverterOutput(
                    label: selectedUnit == .km ? "Required Pace (min/km)" : "Required Pace (min/mi)",
                    value: targetResult ?? (targetDistanceMode == .range || targetTimeMode == .range ? "--:-- - --:--" : "--:--"),
                    unit: selectedUnit.paceLabel
                )

                ActionRow(
                    primaryTitle: "Find Pace",
                    primarySystemImage: "scope",
                    onPrimary: findTargetPace,
                    onClear: clearTarget
                )

                InlineError(targetError)
            }
        }
    }

    @ViewBuilder
    private var timeEstimateInputs: some View {
        VStack(spacing: 10) {
            if distanceMode == .single {
                UnitTextField(
                    label: selectedUnit == .km ? "Distance (km)" : "Distance (mi)",
                    placeholder: "10",
                    text: $distanceInput,
                    unitLabel: selectedUnit.shortLabel,
                    keyboardType: .decimalPad,
                    onUnitTap: toggleUnit
                )
                .onChange(of: distanceInput) { _, value in
                    updateDecimalInput(value, binding: $distanceInput, error: $estimateError)
                }
            } else {
                UnitTextField(
                    label: selectedUnit == .km ? "From (km)" : "From (mi)",
                    placeholder: "From",
                    text: $distanceFromInput,
                    unitLabel: selectedUnit.shortLabel,
                    keyboardType: .decimalPad,
                    onUnitTap: toggleUnit
                )
                .onChange(of: distanceFromInput) { _, value in
                    updateDecimalInput(value, binding: $distanceFromInput, error: $estimateError)
                }

                UnitTextField(
                    label: selectedUnit == .km ? "To (km)" : "To (mi)",
                    placeholder: "To",
                    text: $distanceToInput,
                    unitLabel: selectedUnit.shortLabel,
                    keyboardType: .decimalPad,
                    onUnitTap: toggleUnit
                )
                .onChange(of: distanceToInput) { _, value in
                    updateDecimalInput(value, binding: $distanceToInput, error: $estimateError)
                }
            }

            if paceMode == .single {
                UnitTextField(
                    label: selectedUnit == .km ? "Pace (min/km)" : "Pace (min/mi)",
                    placeholder: "7:40",
                    text: $paceInput,
                    unitLabel: selectedUnit.paceLabel,
                    keyboardType: .numbersAndPunctuation,
                    onUnitTap: toggleUnit
                )
                .onChange(of: paceInput) { _, value in
                    updatePaceInput(value, binding: $paceInput, error: $estimateError)
                }
            } else {
                UnitTextField(
                    label: selectedUnit == .km ? "Faster (min/km)" : "Faster (min/mi)",
                    placeholder: "6:00",
                    text: $fasterPaceInput,
                    unitLabel: selectedUnit.paceLabel,
                    keyboardType: .numbersAndPunctuation,
                    onUnitTap: toggleUnit
                )
                .onChange(of: fasterPaceInput) { _, value in
                    updatePaceInput(value, binding: $fasterPaceInput, error: $estimateError)
                }

                UnitTextField(
                    label: selectedUnit == .km ? "Slower (min/km)" : "Slower (min/mi)",
                    placeholder: "6:30",
                    text: $slowerPaceInput,
                    unitLabel: selectedUnit.paceLabel,
                    keyboardType: .numbersAndPunctuation,
                    onUnitTap: toggleUnit
                )
                .onChange(of: slowerPaceInput) { _, value in
                    updatePaceInput(value, binding: $slowerPaceInput, error: $estimateError)
                }
            }
        }
    }

    @ViewBuilder
    private var targetPaceInputs: some View {
        VStack(spacing: 10) {
            if targetDistanceMode == .single {
                UnitTextField(
                    label: selectedUnit == .km ? "Distance (km)" : "Distance (mi)",
                    placeholder: "5",
                    text: $targetDistanceInput,
                    unitLabel: selectedUnit.shortLabel,
                    keyboardType: .decimalPad,
                    onUnitTap: toggleUnit
                )
                .onChange(of: targetDistanceInput) { _, value in
                    updateDecimalInput(value, binding: $targetDistanceInput, error: $targetError)
                }
            } else {
                UnitTextField(
                    label: selectedUnit == .km ? "From (km)" : "From (mi)",
                    placeholder: "From",
                    text: $targetDistanceFromInput,
                    unitLabel: selectedUnit.shortLabel,
                    keyboardType: .decimalPad,
                    onUnitTap: toggleUnit
                )
                .onChange(of: targetDistanceFromInput) { _, value in
                    updateDecimalInput(value, binding: $targetDistanceFromInput, error: $targetError)
                }

                UnitTextField(
                    label: selectedUnit == .km ? "To (km)" : "To (mi)",
                    placeholder: "To",
                    text: $targetDistanceToInput,
                    unitLabel: selectedUnit.shortLabel,
                    keyboardType: .decimalPad,
                    onUnitTap: toggleUnit
                )
                .onChange(of: targetDistanceToInput) { _, value in
                    updateDecimalInput(value, binding: $targetDistanceToInput, error: $targetError)
                }
            }

            if targetTimeMode == .single {
                PlainTextField(
                    label: "Target Time",
                    placeholder: "20:00",
                    text: $targetTimeInput,
                    keyboardType: .numbersAndPunctuation
                )
                .onChange(of: targetTimeInput) { _, value in
                    updateTargetTimeInput(value, binding: $targetTimeInput, error: $targetError)
                }
            } else {
                PlainTextField(
                    label: "From Time",
                    placeholder: "20:00",
                    text: $targetTimeFromInput,
                    keyboardType: .numbersAndPunctuation
                )
                .onChange(of: targetTimeFromInput) { _, value in
                    updateTargetTimeInput(value, binding: $targetTimeFromInput, error: $targetError)
                }

                PlainTextField(
                    label: "To Time",
                    placeholder: "22:00",
                    text: $targetTimeToInput,
                    keyboardType: .numbersAndPunctuation
                )
                .onChange(of: targetTimeToInput) { _, value in
                    updateTargetTimeInput(value, binding: $targetTimeToInput, error: $targetError)
                }
            }
        }
    }

    private func updateDecimalInput(_ value: String, binding: Binding<String>, error: Binding<String>) {
        let cleaned = RunningConversions.cleanDecimalInput(value)
        if cleaned != value {
            binding.wrappedValue = cleaned
        }
        error.wrappedValue = ""
    }

    private func updatePaceInput(_ value: String, binding: Binding<String>, error: Binding<String>) {
        let sanitized = RunningConversions.sanitizePaceInput(value)
        if sanitized != value {
            binding.wrappedValue = sanitized
        }
        error.wrappedValue = ""
    }

    private func updateTargetTimeInput(_ value: String, binding: Binding<String>, error: Binding<String>) {
        let sanitized = RunningConversions.sanitizeTargetTimeInput(value)
        if sanitized != value {
            binding.wrappedValue = sanitized
        }
        error.wrappedValue = ""
    }

    private func estimateTime() {
        let distanceValues = distanceMode == .range
            ? [RunningConversions.parseDistance(distanceFromInput, requirePositive: true), RunningConversions.parseDistance(distanceToInput, requirePositive: true)]
            : [RunningConversions.parseDistance(distanceInput, requirePositive: true)]

        let paceValues = paceMode == .range
            ? [RunningConversions.parseFlexiblePaceToSeconds(fasterPaceInput), RunningConversions.parseFlexiblePaceToSeconds(slowerPaceInput)]
            : [RunningConversions.parseFlexiblePaceToSeconds(paceInput)]

        guard distanceValues.allSatisfy({ $0 != nil }) else {
            estimateError = distanceMode == .range ? "Enter a valid distance range." : "Enter a valid distance."
            return
        }

        guard paceValues.allSatisfy({ $0 != nil }) else {
            estimateError = paceMode == .range ? "Enter a valid faster and slower pace range." : "Enter a valid pace."
            return
        }

        let distances = distanceValues.compactMap(\.self)
        let paces = paceValues.compactMap(\.self)
        estimateResult = distanceMode == .range || paceMode == .range
            ? RunningConversions.estimateTimeRange(distances: distances, paceSeconds: paces)
            : RunningConversions.estimateTime(distance: distances[0], paceSeconds: paces[0])
        estimateError = ""
    }

    private func findTargetPace() {
        let distanceValues = targetDistanceMode == .range
            ? [RunningConversions.parseDistance(targetDistanceFromInput, requirePositive: true), RunningConversions.parseDistance(targetDistanceToInput, requirePositive: true)]
            : [RunningConversions.parseDistance(targetDistanceInput, requirePositive: true)]

        let timeValues = targetTimeMode == .range
            ? [RunningConversions.parseTargetTimeToSeconds(targetTimeFromInput), RunningConversions.parseTargetTimeToSeconds(targetTimeToInput)]
            : [RunningConversions.parseTargetTimeToSeconds(targetTimeInput)]

        guard distanceValues.allSatisfy({ $0 != nil }) else {
            targetError = targetDistanceMode == .range ? "Enter a valid distance range." : "Enter a valid distance."
            return
        }

        guard timeValues.allSatisfy({ $0 != nil }) else {
            targetError = targetTimeMode == .range ? "Enter a valid target time range." : "Enter a valid target time."
            return
        }

        let distances = distanceValues.compactMap(\.self)
        let times = timeValues.compactMap(\.self)
        targetResult = targetDistanceMode == .range || targetTimeMode == .range
            ? RunningConversions.targetPaceRange(distances: distances, targetTimes: times)
            : RunningConversions.targetPace(distance: distances[0], targetTimeSeconds: times[0])
        targetError = ""
    }

    private func toggleUnit() {
        let nextUnit = selectedUnit.opposite
        targetDistanceInput = RunningConversions.convertDistanceInput(targetDistanceInput, from: selectedUnit, to: nextUnit)
        targetDistanceFromInput = RunningConversions.convertDistanceInput(targetDistanceFromInput, from: selectedUnit, to: nextUnit)
        targetDistanceToInput = RunningConversions.convertDistanceInput(targetDistanceToInput, from: selectedUnit, to: nextUnit)
        selectedUnit = nextUnit
        resetEstimate()
        resetTarget()
    }

    private func resetEstimate() {
        estimateResult = nil
        estimateError = ""
    }

    private func resetTarget() {
        targetResult = nil
        targetError = ""
    }

    private func clearEstimate() {
        distanceInput = ""
        distanceFromInput = ""
        distanceToInput = ""
        paceInput = ""
        fasterPaceInput = ""
        slowerPaceInput = ""
        resetEstimate()
    }

    private func clearTarget() {
        targetDistanceInput = ""
        targetDistanceFromInput = ""
        targetDistanceToInput = ""
        targetTimeInput = ""
        targetTimeFromInput = ""
        targetTimeToInput = ""
        resetTarget()
    }
}

private struct WorkoutConverterScreen: View {
    @State private var mode: WorkoutMode = .normal
    @State private var normalDistance = "8"
    @State private var normalUnit: DistanceUnit = .km
    @State private var normalPaceTarget = EditablePaceTarget(mode: .range, unit: .km, fasterText: "6:00", slowerText: "6:30")
    @State private var warmup = EditableIntervalSection.warmup(defaultUnit: .km)
    @State private var cooldown = EditableIntervalSection.cooldown(defaultUnit: .km)
    @State private var blocks = [EditableRepeatBlock.defaultBlock()]
    @State private var outputUnit: DistanceUnit = .km
    @State private var normalOutput: [String] = []
    @State private var intervalOutput: IntervalSummary?
    @State private var totalDistance: Double = 0
    @State private var error = ""

    private var summaryUnit: DistanceUnit {
        mode == .normal ? normalUnit.opposite : outputUnit
    }

    var body: some View {
        ConverterScrollView(title: "Workout Converter") {
            ConverterCard {
                SectionHeader(title: "Workout Converter", systemImage: "figure.run")

                Picker("Workout mode", selection: $mode) {
                    Text("Normal Run").tag(WorkoutMode.normal)
                    Text("Intervals").tag(WorkoutMode.intervals)
                }
                .pickerStyle(.segmented)
                .onChange(of: mode) { _, _ in clearOutput() }

                if mode == .normal {
                    normalRunEditor
                } else {
                    intervalsEditor
                }

                ActionRow(
                    primaryTitle: "Convert",
                    primarySystemImage: "arrow.triangle.2.circlepath",
                    onPrimary: convert,
                    onClear: clear
                )

                InlineError(error)

                WorkoutSummaryView(
                    totalDistance: totalDistance,
                    unit: summaryUnit,
                    normalOutput: normalOutput,
                    intervalOutput: intervalOutput
                )
            }
        }
    }

    private var normalRunEditor: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                PlainTextField(
                    label: "Distance",
                    placeholder: "8",
                    text: $normalDistance,
                    keyboardType: .decimalPad
                )
                .onChange(of: normalDistance) { _, value in
                    let cleaned = RunningConversions.cleanDecimalInput(value)
                    if cleaned != value { normalDistance = cleaned }
                    clearOutput()
                }

                Picker("Unit", selection: $normalUnit) {
                    ForEach(DistanceUnit.allCases) { unit in
                        Text(unit.distanceLabel).tag(unit)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: 140)
                .onChange(of: normalUnit) { _, _ in clearOutput() }
            }

            PaceTargetEditor(target: $normalPaceTarget, showUnit: false, defaultUnit: normalUnit)
        }
    }

    private var intervalsEditor: some View {
        VStack(alignment: .leading, spacing: 14) {
            Picker("Output unit", selection: $outputUnit) {
                Text("Kilometers").tag(DistanceUnit.km)
                Text("Miles").tag(DistanceUnit.mi)
            }
            .pickerStyle(.segmented)
            .onChange(of: outputUnit) { _, _ in clearOutput() }

            IntervalSectionEditor(section: $warmup)

            VStack(alignment: .leading, spacing: 12) {
                ForEach(blocks.indices, id: \.self) { blockIndex in
                    RepeatBlockEditor(
                        block: $blocks[blockIndex],
                        canDelete: blocks.count > 1,
                        onDelete: {
                            blocks.remove(at: blockIndex)
                            clearOutput()
                        },
                        onChange: clearOutput
                    )
                }
            }

            Button {
                blocks.append(.defaultBlock())
                clearOutput()
            } label: {
                Label("Add Repeat Block", systemImage: "plus")
            }
            .buttonStyle(.bordered)

            IntervalSectionEditor(section: $cooldown)
        }
    }

    private func convert() {
        switch mode {
        case .normal:
            convertNormalRun()
        case .intervals:
            convertIntervals()
        }
    }

    private func convertNormalRun() {
        guard let distance = RunningConversions.parseDistance(normalDistance, requirePositive: true) else {
            error = "Normal Run: enter a valid distance."
            return
        }

        let resolvedTarget: PaceTarget
        do {
            resolvedTarget = try normalPaceTarget.resolved(defaultUnit: normalUnit, includeUnit: false)
        } catch {
            self.error = error.localizedDescription
            return
        }

        let config = NormalRunConfig(distance: distance, unit: normalUnit, paceTarget: resolvedTarget)
        let targetUnit = normalUnit.opposite
        normalOutput = RunningConversions.buildNormalRunSummary(config, sourceUnit: normalUnit, targetUnit: targetUnit)
        intervalOutput = nil
        totalDistance = RunningConversions.calculateNormalRunTotalDistance(config, targetUnit: targetUnit)
        error = ""
    }

    private func convertIntervals() {
        do {
            let resolvedWarmup = try warmup.resolved()
            let resolvedCooldown = try cooldown.resolved()
            let resolvedBlocks = try blocks.map { try $0.resolved() }
            let config = IntervalsConfig(warmup: resolvedWarmup, blocks: resolvedBlocks, cooldown: resolvedCooldown)
            intervalOutput = RunningConversions.buildStructuredIntervalsSummary(config, targetUnit: outputUnit)
            normalOutput = []
            totalDistance = RunningConversions.calculateIntervalsTotalDistance(config, targetUnit: outputUnit)
            error = ""
        } catch {
            self.error = error.localizedDescription
        }
    }

    private func clearOutput() {
        normalOutput = []
        intervalOutput = nil
        totalDistance = 0
        error = ""
    }

    private func clear() {
        mode = .normal
        normalDistance = "8"
        normalUnit = .km
        normalPaceTarget = EditablePaceTarget(mode: .range, unit: .km, fasterText: "6:00", slowerText: "6:30")
        warmup = .warmup(defaultUnit: .km)
        cooldown = .cooldown(defaultUnit: .km)
        blocks = [.defaultBlock()]
        outputUnit = .km
        clearOutput()
    }
}

private struct ConverterScrollView<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                content
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .scrollDismissesKeyboard(.interactively)
    }
}

private struct ConverterCard<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            content
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(Color(.separator).opacity(0.35), lineWidth: 1)
        }
    }
}

private struct SectionHeader: View {
    let title: String
    let systemImage: String

    var body: some View {
        Label(title, systemImage: systemImage)
            .font(.title3.weight(.semibold))
            .labelStyle(.titleAndIcon)
    }
}

private struct UnitTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    let unitLabel: String
    let keyboardType: UIKeyboardType
    let onUnitTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            HStack(spacing: 8) {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(.never)
                    .font(.title2.monospacedDigit())

                Button(unitLabel, action: onUnitTap)
                    .buttonStyle(.bordered)
                    .font(.body.monospacedDigit().weight(.semibold))
            }
            .padding(12)
            .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color(.separator).opacity(0.5), lineWidth: 1)
            }
        }
    }
}

private struct PlainTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    let keyboardType: UIKeyboardType

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(.never)
                .font(.title3.monospacedDigit())
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color(.separator).opacity(0.5), lineWidth: 1)
                }
        }
    }
}

private struct ConverterOutput: View {
    let label: String
    let value: String
    let unit: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            HStack(alignment: .firstTextBaseline) {
                Text(value)
                    .font(.system(.title, design: .rounded, weight: .semibold))
                    .monospacedDigit()
                    .lineLimit(2)
                    .minimumScaleFactor(0.72)

                if !unit.isEmpty {
                    Text(unit)
                        .font(.callout.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color(.separator).opacity(0.45), lineWidth: 1)
            }
        }
    }
}

private struct ActionRow: View {
    let primaryTitle: String
    let primarySystemImage: String
    let onPrimary: () -> Void
    let onClear: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Button(action: onPrimary) {
                Label(primaryTitle, systemImage: primarySystemImage)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            Button(action: onClear) {
                Label("Clear", systemImage: "xmark")
                    .frame(minWidth: 88)
            }
            .buttonStyle(.bordered)
        }
        .controlSize(.large)
    }
}

private struct InlineError: View {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    var body: some View {
        Text(message.isEmpty ? " " : message)
            .font(.footnote)
            .foregroundStyle(message.isEmpty ? .clear : .red)
            .accessibilityHidden(message.isEmpty)
    }
}

private struct TargetDistancePreset: Identifiable {
    let label: String
    let km: String
    let mi: String

    var id: String { label }

    func value(for unit: DistanceUnit) -> String {
        unit == .km ? km : mi
    }
}

private struct EditablePaceTarget: Hashable {
    var mode: PaceTargetMode = .none
    var unit: DistanceUnit = .km
    var valueText = ""
    var fasterText = ""
    var slowerText = ""

    func resolved(defaultUnit: DistanceUnit, includeUnit: Bool) throws -> PaceTarget {
        switch mode {
        case .none:
            return PaceTarget(mode: .none)
        case .value:
            guard let value = RunningConversions.parseFlexiblePaceToSeconds(valueText) else {
                throw ConverterValidationError("Enter pace as m:ss.")
            }
            return PaceTarget(mode: .value, unit: includeUnit ? unit : nil, value: value)
        case .range:
            guard let faster = RunningConversions.parseFlexiblePaceToSeconds(fasterText),
                  let slower = RunningConversions.parseFlexiblePaceToSeconds(slowerText),
                  faster <= slower
            else {
                throw ConverterValidationError("Enter a valid faster and slower pace range.")
            }
            return PaceTarget(mode: .range, unit: includeUnit ? unit : nil, min: faster, max: slower)
        }
    }

    mutating func sanitizeFields() {
        valueText = RunningConversions.sanitizePaceInput(valueText)
        fasterText = RunningConversions.sanitizePaceInput(fasterText)
        slowerText = RunningConversions.sanitizePaceInput(slowerText)
    }
}

private struct EditableIntervalSection: Identifiable, Hashable {
    var id = UUID()
    var role: IntervalSectionRole
    var label: String
    var goalType: GoalType
    var distanceText: String
    var unit: WorkoutDistanceUnit
    var durationText: String
    var paceTarget: EditablePaceTarget

    static func warmup(defaultUnit: DistanceUnit) -> EditableIntervalSection {
        EditableIntervalSection(
            role: .warmup,
            label: "Warm-up",
            goalType: .distance,
            distanceText: "1",
            unit: defaultUnit == .mi ? .mi : .km,
            durationText: "",
            paceTarget: EditablePaceTarget(mode: .range, unit: defaultUnit, fasterText: "6:00", slowerText: "6:30")
        )
    }

    static func cooldown(defaultUnit: DistanceUnit) -> EditableIntervalSection {
        EditableIntervalSection(
            role: .cooldown,
            label: "Cool-down",
            goalType: .open,
            distanceText: "",
            unit: defaultUnit == .mi ? .mi : .km,
            durationText: "",
            paceTarget: EditablePaceTarget()
        )
    }

    static func blockStep(role: IntervalSectionRole) -> EditableIntervalSection {
        if role == .recovery {
            return EditableIntervalSection(
                role: .recovery,
                label: "Recovery",
                goalType: .time,
                distanceText: "",
                unit: .km,
                durationText: "02:00",
                paceTarget: EditablePaceTarget()
            )
        }

        return EditableIntervalSection(
            role: .work,
            label: "Work",
            goalType: .distance,
            distanceText: "400",
            unit: .m,
            durationText: "",
            paceTarget: EditablePaceTarget(mode: .value, unit: .km, valueText: "4:30")
        )
    }

    mutating func changeRole(to nextRole: IntervalSectionRole) {
        let currentID = id
        self = .blockStep(role: nextRole)
        id = currentID
    }

    func resolved() throws -> IntervalSection {
        let resolvedTarget = try paceTarget.resolved(defaultUnit: unit.mainUnit, includeUnit: true)

        switch goalType {
        case .distance:
            guard let distance = RunningConversions.parseDistance(distanceText, requirePositive: true) else {
                throw ConverterValidationError("\(label): enter a valid distance.")
            }

            return IntervalSection(
                id: id,
                role: role,
                label: label,
                goalType: goalType,
                distance: distance,
                unit: unit,
                paceTarget: resolvedTarget
            )
        case .time:
            guard let duration = RunningConversions.normalizeDuration(durationText) else {
                throw ConverterValidationError("\(label): enter time as mm:ss or hh:mm:ss.")
            }

            return IntervalSection(
                id: id,
                role: role,
                label: label,
                goalType: goalType,
                duration: duration,
                paceTarget: resolvedTarget
            )
        case .open:
            return IntervalSection(
                id: id,
                role: role,
                label: label,
                goalType: goalType,
                paceTarget: resolvedTarget
            )
        }
    }
}

private struct EditableRepeatBlock: Identifiable, Hashable {
    var id = UUID()
    var repeatCount = 5
    var steps: [EditableIntervalSection]

    static func defaultBlock() -> EditableRepeatBlock {
        EditableRepeatBlock(steps: [.blockStep(role: .work), .blockStep(role: .recovery)])
    }

    func resolved() throws -> RepeatBlock {
        guard repeatCount >= 1 else {
            throw ConverterValidationError("Repeat Block: repeat count must be at least 1.")
        }

        return RepeatBlock(id: id, repeatCount: repeatCount, steps: try steps.map { try $0.resolved() })
    }
}

private struct RepeatBlockEditor: View {
    @Binding var block: EditableRepeatBlock
    let canDelete: Bool
    let onDelete: () -> Void
    let onChange: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Block Sequence")
                    .font(.headline)
                Spacer()
                if canDelete {
                    Button(role: .destructive, action: onDelete) {
                        Label("Delete", systemImage: "trash")
                    }
                    .labelStyle(.iconOnly)
                }
            }

            Stepper(value: $block.repeatCount, in: 1...99) {
                Text("Repeat \(block.repeatCount)x")
            }
            .onChange(of: block.repeatCount) { _, _ in onChange() }

            ForEach(block.steps.indices, id: \.self) { stepIndex in
                IntervalSectionEditor(section: $block.steps[stepIndex], allowRoleChange: true) {
                    if block.steps.count > 1 {
                        Button(role: .destructive) {
                            block.steps.remove(at: stepIndex)
                            onChange()
                        } label: {
                            Label("Delete step", systemImage: "minus.circle")
                        }
                        .labelStyle(.iconOnly)
                    }
                }
            }

            Button {
                block.steps.append(.blockStep(role: block.steps.last?.role == .work ? .recovery : .work))
                onChange()
            } label: {
                Label("Add Step", systemImage: "plus")
            }
            .buttonStyle(.bordered)
        }
        .padding(14)
        .background(Color(.tertiarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

private struct PaceTargetEditor: View {
    @Binding var target: EditablePaceTarget
    var showUnit: Bool
    var defaultUnit: DistanceUnit

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Picker("Effort", selection: $target.mode) {
                ForEach(PaceTargetMode.allCases) { mode in
                    Text(mode.label).tag(mode)
                }
            }
            .pickerStyle(.segmented)

            if target.mode == .value {
                UnitTextField(
                    label: "Pace",
                    placeholder: "6:30",
                    text: $target.valueText,
                    unitLabel: showUnit ? target.unit.paceLabel : defaultUnit.paceLabel,
                    keyboardType: .numbersAndPunctuation,
                    onUnitTap: toggleUnit
                )
                .onChange(of: target.valueText) { _, value in
                    target.valueText = RunningConversions.sanitizePaceInput(value)
                }
            }

            if target.mode == .range {
                UnitTextField(
                    label: "Faster Pace",
                    placeholder: "6:00",
                    text: $target.fasterText,
                    unitLabel: showUnit ? target.unit.paceLabel : defaultUnit.paceLabel,
                    keyboardType: .numbersAndPunctuation,
                    onUnitTap: toggleUnit
                )
                .onChange(of: target.fasterText) { _, value in
                    target.fasterText = RunningConversions.sanitizePaceInput(value)
                }

                UnitTextField(
                    label: "Slower Pace",
                    placeholder: "6:30",
                    text: $target.slowerText,
                    unitLabel: showUnit ? target.unit.paceLabel : defaultUnit.paceLabel,
                    keyboardType: .numbersAndPunctuation,
                    onUnitTap: toggleUnit
                )
                .onChange(of: target.slowerText) { _, value in
                    target.slowerText = RunningConversions.sanitizePaceInput(value)
                }
            }
        }
    }

    private func toggleUnit() {
        guard showUnit else { return }
        let nextUnit = target.unit.opposite
        convertPaceText(&target.valueText, from: target.unit, to: nextUnit)
        convertPaceText(&target.fasterText, from: target.unit, to: nextUnit)
        convertPaceText(&target.slowerText, from: target.unit, to: nextUnit)
        target.unit = nextUnit
    }

    private func convertPaceText(_ text: inout String, from unit: DistanceUnit, to targetUnit: DistanceUnit) {
        guard let seconds = RunningConversions.parseFlexiblePaceToSeconds(text) else {
            text = RunningConversions.sanitizePaceInput(text)
            return
        }

        text = RunningConversions.formatPace(RunningConversions.convertPace(seconds, from: unit, to: targetUnit))
    }
}

private struct IntervalSectionEditor<Trailing: View>: View {
    @Binding var section: EditableIntervalSection
    var allowRoleChange = false
    @ViewBuilder var trailing: Trailing

    init(
        section: Binding<EditableIntervalSection>,
        allowRoleChange: Bool = false,
        @ViewBuilder trailing: () -> Trailing = { EmptyView() }
    ) {
        self._section = section
        self.allowRoleChange = allowRoleChange
        self.trailing = trailing()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(section.label)
                        .font(.headline)
                    Text(summaryText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                Spacer()
                trailing
            }

            if allowRoleChange {
                Picker("Step Role", selection: roleBinding) {
                    Text("Work").tag(IntervalSectionRole.work)
                    Text("Recovery").tag(IntervalSectionRole.recovery)
                }
                .pickerStyle(.segmented)
            }

            Picker("Goal Type", selection: $section.goalType) {
                ForEach(GoalType.allCases) { goal in
                    Text(goal.label).tag(goal)
                }
            }
            .pickerStyle(.segmented)

            if section.goalType == .distance {
                HStack(spacing: 10) {
                    PlainTextField(
                        label: "Distance",
                        placeholder: section.unit == .m ? "400" : "1",
                        text: $section.distanceText,
                        keyboardType: .decimalPad
                    )
                    .onChange(of: section.distanceText) { _, value in
                        section.distanceText = RunningConversions.cleanDecimalInput(value)
                    }

                    Picker("Unit", selection: $section.unit) {
                        ForEach(WorkoutDistanceUnit.allCases) { unit in
                            Text(unit.label).tag(unit)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: 128)
                }
            }

            if section.goalType == .time {
                PlainTextField(
                    label: "Time",
                    placeholder: "02:00",
                    text: $section.durationText,
                    keyboardType: .numbersAndPunctuation
                )
                .onChange(of: section.durationText) { _, value in
                    section.durationText = RunningConversions.sanitizeDurationInput(value)
                }
            }

            PaceTargetEditor(target: $section.paceTarget, showUnit: true, defaultUnit: section.unit.mainUnit)
        }
        .padding(14)
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(Color(.separator).opacity(0.4), lineWidth: 1)
        }
    }

    private var roleBinding: Binding<IntervalSectionRole> {
        Binding {
            section.role
        } set: { nextRole in
            section.changeRole(to: nextRole)
        }
    }

    private var summaryText: String {
        guard let resolved = try? section.resolved() else {
            return "Not converted"
        }
        return RunningConversions.summarizeIntervalSection(resolved)
    }
}

private struct WorkoutSummaryView: View {
    let totalDistance: Double
    let unit: DistanceUnit
    let normalOutput: [String]
    let intervalOutput: IntervalSummary?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Converted Workout")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            Text("\(RunningConversions.formatDistance(totalDistance)) \(unit.rawValue) total")
                .font(.headline.monospacedDigit())

            if let intervalOutput {
                Text(intervalOutput.warmup)

                ForEach(intervalOutput.blocks, id: \.title) { block in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(block.title)
                            .font(.subheadline.weight(.semibold))
                        ForEach(block.steps, id: \.self) { step in
                            Text(step)
                                .font(.subheadline)
                        }
                    }
                }

                Text(intervalOutput.cooldown)
            } else if !normalOutput.isEmpty {
                ForEach(normalOutput, id: \.self) { line in
                    Text(line)
                }
            } else {
                Text("--")
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(Color(.separator).opacity(0.45), lineWidth: 1)
        }
    }
}

private struct ConverterValidationError: LocalizedError {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    var errorDescription: String? {
        message
    }
}

#Preview {
    ContentView()
}
