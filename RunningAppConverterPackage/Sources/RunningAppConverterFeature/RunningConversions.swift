import Foundation

public enum DistanceUnit: String, CaseIterable, Identifiable, Hashable {
    case km
    case mi

    public var id: String { rawValue }

    public var shortLabel: String {
        switch self {
        case .km: "KM"
        case .mi: "MI"
        }
    }

    public var distanceLabel: String {
        switch self {
        case .km: "Kilometers"
        case .mi: "Miles"
        }
    }

    public var paceLabel: String {
        switch self {
        case .km: "/km"
        case .mi: "/mi"
        }
    }

    public var opposite: DistanceUnit {
        switch self {
        case .km: .mi
        case .mi: .km
        }
    }
}

public enum WorkoutDistanceUnit: String, CaseIterable, Identifiable, Hashable {
    case km
    case mi
    case m

    public var id: String { rawValue }

    public var label: String {
        switch self {
        case .km: "Kilometers"
        case .mi: "Miles"
        case .m: "Meters"
        }
    }

    public var mainUnit: DistanceUnit {
        switch self {
        case .mi: .mi
        case .km, .m: .km
        }
    }
}

public enum ConversionInputMode: String, CaseIterable, Identifiable, Hashable {
    case single
    case range

    public var id: String { rawValue }
}

public enum WorkoutMode: String, CaseIterable, Identifiable, Hashable {
    case normal
    case intervals

    public var id: String { rawValue }
}

public enum GoalType: String, CaseIterable, Identifiable, Hashable {
    case distance
    case time
    case open

    public var id: String { rawValue }

    public var label: String {
        switch self {
        case .distance: "Distance"
        case .time: "Time"
        case .open: "Open"
        }
    }
}

public enum PaceTargetMode: String, CaseIterable, Identifiable, Hashable {
    case none
    case value
    case range

    public var id: String { rawValue }

    public var label: String {
        switch self {
        case .none: "None"
        case .value: "Single Pace"
        case .range: "Pace Range"
        }
    }
}

public enum IntervalSectionRole: String, CaseIterable, Identifiable, Hashable {
    case warmup
    case work
    case recovery
    case cooldown

    public var id: String { rawValue }

    public var label: String {
        switch self {
        case .warmup: "Warm-up"
        case .work: "Work"
        case .recovery: "Recovery"
        case .cooldown: "Cool-down"
        }
    }
}

public struct PaceTarget: Equatable, Hashable {
    public var mode: PaceTargetMode
    public var unit: DistanceUnit?
    public var value: Int?
    public var min: Int?
    public var max: Int?

    public init(
        mode: PaceTargetMode,
        unit: DistanceUnit? = nil,
        value: Int? = nil,
        min: Int? = nil,
        max: Int? = nil
    ) {
        self.mode = mode
        self.unit = unit
        self.value = value
        self.min = min
        self.max = max
    }
}

public struct NormalRunConfig: Equatable, Hashable {
    public var distance: Double
    public var unit: DistanceUnit
    public var paceTarget: PaceTarget

    public init(distance: Double, unit: DistanceUnit, paceTarget: PaceTarget) {
        self.distance = distance
        self.unit = unit
        self.paceTarget = paceTarget
    }
}

public struct IntervalSection: Identifiable, Equatable, Hashable {
    public var id: UUID
    public var role: IntervalSectionRole
    public var label: String
    public var goalType: GoalType
    public var distance: Double?
    public var unit: WorkoutDistanceUnit?
    public var duration: String?
    public var paceTarget: PaceTarget

    public init(
        id: UUID,
        role: IntervalSectionRole,
        label: String,
        goalType: GoalType,
        distance: Double? = nil,
        unit: WorkoutDistanceUnit? = nil,
        duration: String? = nil,
        paceTarget: PaceTarget
    ) {
        self.id = id
        self.role = role
        self.label = label
        self.goalType = goalType
        self.distance = distance
        self.unit = unit
        self.duration = duration
        self.paceTarget = paceTarget
    }
}

public struct RepeatBlock: Identifiable, Equatable, Hashable {
    public var id: UUID
    public var repeatCount: Int
    public var steps: [IntervalSection]

    public init(id: UUID, repeatCount: Int, steps: [IntervalSection]) {
        self.id = id
        self.repeatCount = repeatCount
        self.steps = steps
    }
}

public struct IntervalsConfig: Equatable, Hashable {
    public var warmup: IntervalSection
    public var blocks: [RepeatBlock]
    public var cooldown: IntervalSection

    public init(warmup: IntervalSection, blocks: [RepeatBlock], cooldown: IntervalSection) {
        self.warmup = warmup
        self.blocks = blocks
        self.cooldown = cooldown
    }
}

public struct IntervalSummaryBlock: Equatable, Hashable {
    public var title: String
    public var steps: [String]

    public init(title: String, steps: [String]) {
        self.title = title
        self.steps = steps
    }
}

public struct IntervalSummary: Equatable, Hashable {
    public var warmup: String
    public var blocks: [IntervalSummaryBlock]
    public var cooldown: String

    public init(warmup: String, blocks: [IntervalSummaryBlock], cooldown: String) {
        self.warmup = warmup
        self.blocks = blocks
        self.cooldown = cooldown
    }
}

public enum RunningConversions {
    public static let kmToMi = 0.621371
    public static let miToKm = 1.60934

    public static func convertDistance(_ distance: Double, from unit: DistanceUnit, to targetUnit: DistanceUnit) -> Double {
        guard distance.isFinite else { return 0 }
        guard unit != targetUnit else { return roundToTwoDecimals(distance) }

        switch unit {
        case .km:
            return roundToTwoDecimals(distance * kmToMi)
        case .mi:
            return roundToTwoDecimals(distance * miToKm)
        }
    }

    public static func convertDistance(_ distance: Double, from unit: WorkoutDistanceUnit, to targetUnit: DistanceUnit) -> Double {
        guard distance.isFinite else { return 0 }

        var distanceInKm = distance
        switch unit {
        case .km:
            distanceInKm = distance
        case .mi:
            distanceInKm = distance * miToKm
        case .m:
            distanceInKm = distance / 1_000
        }

        return roundToTwoDecimals(targetUnit == .km ? distanceInKm : distanceInKm * kmToMi)
    }

    public static func convertPace(_ seconds: Int, from unit: DistanceUnit, to targetUnit: DistanceUnit) -> Int {
        guard unit != targetUnit else { return seconds }

        let converted = unit == .km ? Double(seconds) * miToKm : Double(seconds) / miToKm
        return Int(converted.rounded())
    }

    public static func parseDistance(_ value: String, requirePositive: Bool = false) -> Double? {
        let normalized = value.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: ",", with: ".")
        guard let number = Double(normalized), number.isFinite else { return nil }
        guard !requirePositive || number > 0 else { return nil }
        return number
    }

    public static func cleanDecimalInput(_ value: String) -> String {
        let normalized = value.replacingOccurrences(of: ",", with: ".")
        var output = ""
        var hasDecimal = false

        for character in normalized {
            if character.isWholeNumber {
                output.append(character)
            } else if character == ".", !hasDecimal {
                output.append(character)
                hasDecimal = true
            }
        }

        return output
    }

    public static func sanitizePaceInput(_ value: String) -> String {
        let sanitized = value.filter { $0.isWholeNumber || $0 == ":" }
        guard !sanitized.isEmpty else { return "" }

        if sanitized.contains(":") {
            let parts = sanitized.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: false)
            let rawMinutes = parts.first.map(String.init) ?? ""
            let rawSeconds = parts.count > 1 ? String(parts[1]) : ""
            let secondsDigits = onlyDigits(rawSeconds)

            if secondsDigits.count > 2 {
                let collapsedDigits = String(onlyDigits(sanitized).prefix(4))
                guard collapsedDigits.count > 2 else { return collapsedDigits }
                return "\(String(collapsedDigits.dropLast(2))):\(String(collapsedDigits.suffix(2)))"
            }

            let minutes = String(onlyDigits(rawMinutes).prefix(3))
            let seconds = String(secondsDigits.prefix(2))

            if minutes.isEmpty {
                return seconds.isEmpty ? "" : "0:\(seconds)"
            }

            return seconds.isEmpty ? "\(minutes):" : "\(minutes):\(seconds)"
        }

        let digits = String(onlyDigits(sanitized).prefix(4))
        guard digits.count > 2 else { return digits }
        return "\(String(digits.dropLast(2))):\(String(digits.suffix(2)))"
    }

    public static func sanitizeDurationInput(_ value: String) -> String {
        let sanitized = value.filter { $0.isWholeNumber || $0 == ":" }
        guard !sanitized.isEmpty else { return "" }

        if sanitized.contains(":") {
            let parts = sanitized.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: false)
            let rawMinutes = parts.first.map(String.init) ?? ""
            let rawSeconds = parts.count > 1 ? String(parts[1]) : ""
            let minutes = String(onlyDigits(rawMinutes).prefix(2))
            let seconds = String(onlyDigits(rawSeconds).prefix(2))

            if minutes.isEmpty {
                return seconds.isEmpty ? "" : "0:\(seconds)"
            }

            return seconds.isEmpty ? "\(minutes):" : "\(minutes):\(seconds)"
        }

        let digits = String(onlyDigits(sanitized).prefix(4))
        guard digits.count > 2 else { return digits }
        return "\(String(digits.dropLast(2))):\(String(digits.suffix(2)))"
    }

    public static func sanitizeTargetTimeInput(_ value: String) -> String {
        let sanitized = value.filter { $0.isWholeNumber || $0 == ":" }
        guard !sanitized.isEmpty else { return "" }

        if sanitized.contains(":") {
            let collapsedDigits = String(onlyDigits(sanitized).prefix(6))
            let parts = sanitized.split(separator: ":", maxSplits: 2, omittingEmptySubsequences: false)
            let hasOverflow = parts.dropFirst().contains { onlyDigits(String($0)).count > 2 }

            if hasOverflow {
                if collapsedDigits.count <= 3 {
                    return collapsedDigits
                }
                if collapsedDigits.count <= 4 {
                    return "\(String(collapsedDigits.dropLast(2))):\(String(collapsedDigits.suffix(2)))"
                }
                let hours = String(collapsedDigits.dropLast(4))
                let minutes = String(collapsedDigits.dropLast(2).suffix(2))
                let seconds = String(collapsedDigits.suffix(2))
                return "\(hours):\(minutes):\(seconds)"
            }

            return parts.enumerated()
                .map { index, part in String(onlyDigits(String(part)).prefix(index == 0 ? 3 : 2)) }
                .joined(separator: ":")
        }

        let digits = String(onlyDigits(sanitized).prefix(6))
        if digits.count <= 3 {
            return digits
        }
        if digits.count <= 4 {
            return "\(String(digits.dropLast(2))):\(String(digits.suffix(2)))"
        }
        return "\(String(digits.dropLast(4))):\(String(digits.dropLast(2).suffix(2))):\(String(digits.suffix(2)))"
    }

    public static func parseFlexiblePaceToSeconds(_ value: String) -> Int? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        if !trimmed.contains(":") {
            let digits = onlyDigits(trimmed)
            guard !digits.isEmpty, digits.count <= 4 else { return nil }

            let minutes: Int
            let seconds: Int
            if digits.count <= 2 {
                minutes = Int(digits) ?? -1
                seconds = 0
            } else {
                minutes = Int(digits.dropLast(2)) ?? -1
                seconds = Int(digits.suffix(2)) ?? -1
            }

            guard minutes <= 59, seconds <= 59, minutes >= 0, seconds >= 0 else { return nil }
            return minutes * 60 + seconds
        }

        let parts = trimmed.split(separator: ":", omittingEmptySubsequences: false)
        guard parts.count == 2 else { return nil }

        let minutePart = String(parts[0])
        let secondPart = String(parts[1])
        guard (1...3).contains(minutePart.count),
              (1...2).contains(secondPart.count),
              minutePart.allSatisfy(\.isWholeNumber),
              secondPart.allSatisfy(\.isWholeNumber),
              let minutes = Int(minutePart),
              let seconds = Int(secondPart),
              minutes <= 59,
              seconds <= 59
        else {
            return nil
        }

        return minutes * 60 + seconds
    }

    public static func parseTargetTimeToSeconds(_ value: String) -> Int? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        let digits = onlyDigits(trimmed)

        if !trimmed.contains(":") {
            guard !digits.isEmpty, digits.count <= 6 else { return nil }

            if digits.count <= 2 {
                return (Int(digits) ?? 0) * 60
            }

            if digits.count <= 4 {
                let minutes = Int(digits.dropLast(2)) ?? -1
                let seconds = Int(digits.suffix(2)) ?? -1
                return seconds <= 59 ? minutes * 60 + seconds : nil
            }

            let hours = Int(digits.dropLast(4)) ?? -1
            let minutes = Int(digits.dropLast(2).suffix(2)) ?? -1
            let seconds = Int(digits.suffix(2)) ?? -1
            return minutes <= 59 && seconds <= 59 ? hours * 3_600 + minutes * 60 + seconds : nil
        }

        let parts = trimmed.split(separator: ":", omittingEmptySubsequences: false)
        guard (2...3).contains(parts.count), parts.allSatisfy({ !$0.isEmpty }) else { return nil }

        let numericParts = parts.compactMap { Int($0) }
        guard numericParts.count == parts.count, numericParts.allSatisfy({ $0 >= 0 }) else { return nil }

        if numericParts.count == 2 {
            let minutes = numericParts[0]
            let seconds = numericParts[1]
            return seconds <= 59 ? minutes * 60 + seconds : nil
        }

        let hours = numericParts[0]
        let minutes = numericParts[1]
        let seconds = numericParts[2]
        guard minutes <= 59, seconds <= 59 else { return nil }

        let totalSeconds = hours * 3_600 + minutes * 60 + seconds
        return totalSeconds > 0 ? totalSeconds : nil
    }

    public static func normalizeDuration(_ value: String?) -> String? {
        let trimmed = value?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !trimmed.isEmpty else { return "" }

        if !trimmed.contains(":") {
            guard let minutes = Int(trimmed), minutes >= 0 else { return nil }
            return "\(minutes):00"
        }

        let parts = trimmed.split(separator: ":", omittingEmptySubsequences: false)
        guard (2...3).contains(parts.count), parts.allSatisfy({ !$0.isEmpty }) else { return nil }

        let values = parts.compactMap { Int($0) }
        guard values.count == parts.count, values.allSatisfy({ $0 >= 0 }) else { return nil }

        if parts.count == 2 {
            return values[1] <= 59 ? trimmed : nil
        }

        return values[1] <= 59 && values[2] <= 59 ? trimmed : nil
    }

    public static func formatPace(_ totalSeconds: Int) -> String {
        let safeSeconds = max(0, totalSeconds)
        let minutes = safeSeconds / 60
        let seconds = safeSeconds % 60
        return "\(minutes):\(String(format: "%02d", seconds))"
    }

    public static func formatTime(_ totalSeconds: Double) -> String {
        let safeSeconds = max(0, Int(totalSeconds.rounded()))
        let hours = safeSeconds / 3_600
        let minutes = (safeSeconds % 3_600) / 60
        let seconds = safeSeconds % 60

        if hours > 0 {
            return "\(hours):\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
        }

        return "\(minutes):\(String(format: "%02d", seconds))"
    }

    public static func formatDistance(_ distance: Double) -> String {
        String(format: "%.2f", roundToTwoDecimals(distance))
    }

    public static func estimateTime(distance: Double, paceSeconds: Int) -> String {
        formatTime(distance * Double(paceSeconds))
    }

    public static func estimateTimeRange(distances: [Double], paceSeconds: [Int]) -> String {
        let distanceRange = orderedRange(distances.count == 2 ? distances : [distances[0], distances[0]])
        let paceRange = orderedRange(paceSeconds.map(Double.init).count == 2 ? paceSeconds.map(Double.init) : [Double(paceSeconds[0]), Double(paceSeconds[0])])
        return "\(formatTime(distanceRange.lower * paceRange.lower)) - \(formatTime(distanceRange.upper * paceRange.upper))"
    }

    public static func targetPace(distance: Double, targetTimeSeconds: Int) -> String {
        formatTime(Double(targetTimeSeconds) / distance)
    }

    public static func targetPaceRange(distances: [Double], targetTimes: [Int]) -> String {
        let distanceRange = orderedRange(distances.count == 2 ? distances : [distances[0], distances[0]])
        let timeRange = orderedRange(targetTimes.map(Double.init).count == 2 ? targetTimes.map(Double.init) : [Double(targetTimes[0]), Double(targetTimes[0])])
        let fastestPace = timeRange.lower / distanceRange.upper
        let slowestPace = timeRange.upper / distanceRange.lower
        return "\(formatTime(fastestPace)) - \(formatTime(slowestPace))"
    }

    public static func convertDistanceInput(_ value: String, from unit: DistanceUnit, to targetUnit: DistanceUnit) -> String {
        guard let distance = parseDistance(value), unit != targetUnit else { return value }

        let converted = unit == .km ? distance / 1.609344 : distance * 1.609344
        let rounded = (converted * 10).rounded() / 10
        return rounded.rounded() == rounded ? String(Int(rounded)) : String(format: "%.1f", rounded)
    }

    public static func buildNormalRunSummary(_ config: NormalRunConfig, sourceUnit: DistanceUnit, targetUnit: DistanceUnit) -> [String] {
        let distance = "\(formatDistance(convertDistance(config.distance, from: config.unit, to: targetUnit))) \(targetUnit.rawValue)"
        let pace = formatPaceTarget(config.paceTarget, sourceUnit: sourceUnit, targetUnit: targetUnit)
        return ["Normal Run: \(distance)\(pace)".trimmingCharacters(in: .whitespacesAndNewlines)]
    }

    public static func buildStructuredIntervalsSummary(_ config: IntervalsConfig, targetUnit: DistanceUnit) -> IntervalSummary {
        let warmup = "\(config.warmup.label): \(formatGoalValue(config.warmup, targetUnit: targetUnit))\(formatPaceTarget(config.warmup.paceTarget, sourceUnit: config.warmup.paceTarget.unit ?? .km, targetUnit: targetUnit))"

        let blocks = config.blocks.enumerated().map { index, block in
            IntervalSummaryBlock(
                title: "Block \(index + 1) (Repeat \(block.repeatCount)x)",
                steps: block.steps.map { step in
                    "\(step.label): \(formatGoalValue(step, targetUnit: targetUnit))\(formatPaceTarget(step.paceTarget, sourceUnit: step.paceTarget.unit ?? .km, targetUnit: targetUnit))"
                }
            )
        }

        let cooldown = "\(config.cooldown.label): \(formatGoalValue(config.cooldown, targetUnit: targetUnit))\(formatPaceTarget(config.cooldown.paceTarget, sourceUnit: config.cooldown.paceTarget.unit ?? .km, targetUnit: targetUnit))"
        return IntervalSummary(warmup: warmup, blocks: blocks, cooldown: cooldown)
    }

    public static func calculateNormalRunTotalDistance(_ config: NormalRunConfig, targetUnit: DistanceUnit) -> Double {
        convertDistance(config.distance, from: config.unit, to: targetUnit)
    }

    public static func calculateIntervalsTotalDistance(_ config: IntervalsConfig, targetUnit: DistanceUnit) -> Double {
        let fixedTotal = [config.warmup, config.cooldown].reduce(0.0) { total, section in
            guard section.goalType == .distance,
                  let distance = section.distance,
                  let unit = section.unit
            else {
                return total
            }

            return total + convertDistance(distance, from: unit, to: targetUnit)
        }

        let repeatedTotal = config.blocks.reduce(0.0) { blockTotal, block in
            let stepTotal = block.steps.reduce(0.0) { stepTotal, section in
                guard section.goalType == .distance,
                      let distance = section.distance,
                      let unit = section.unit
                else {
                    return stepTotal
                }

                return stepTotal + convertDistance(distance, from: unit, to: targetUnit)
            }

            return blockTotal + stepTotal * Double(block.repeatCount)
        }

        return roundToTwoDecimals(fixedTotal + repeatedTotal)
    }

    public static func summarizePaceTarget(_ target: PaceTarget) -> String {
        let unitLabel = target.unit.map { "/\($0.rawValue)" } ?? ""

        switch target.mode {
        case .none:
            return ""
        case .value:
            guard let value = target.value else { return "" }
            return " - \(formatPace(value))\(unitLabel)"
        case .range:
            guard let min = target.min, let max = target.max else { return "" }
            return " - \(formatPace(min))-\(formatPace(max))\(unitLabel)"
        }
    }

    public static func summarizeIntervalSection(_ section: IntervalSection) -> String {
        "\(formatGoalValue(section, targetUnit: section.unit?.mainUnit ?? .km))\(summarizePaceTarget(section.paceTarget))"
    }

    public static func roundToTwoDecimals(_ value: Double) -> Double {
        (value * 100).rounded() / 100
    }

    private static func formatGoalValue(_ section: IntervalSection, targetUnit: DistanceUnit) -> String {
        switch section.goalType {
        case .open:
            return "Open"
        case .time:
            return section.duration?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false ? section.duration ?? "0:00" : "0:00"
        case .distance:
            guard let distance = section.distance, let unit = section.unit else { return "" }
            return formatStepDistance(distance, unit: unit, targetUnit: targetUnit)
        }
    }

    private static func formatStepDistance(_ distance: Double, unit: WorkoutDistanceUnit, targetUnit: DistanceUnit) -> String {
        if unit == .m {
            return "\(formatCleanNumber(roundToTwoDecimals(distance))) m"
        }

        return "\(formatDistance(convertDistance(distance, from: unit, to: targetUnit))) \(targetUnit.rawValue)"
    }

    private static func formatPaceTarget(_ target: PaceTarget, sourceUnit: DistanceUnit, targetUnit: DistanceUnit) -> String {
        switch target.mode {
        case .none:
            return ""
        case .value:
            guard let value = target.value else { return "" }
            return " @ \(formatPace(convertPace(value, from: sourceUnit, to: targetUnit)))/\(targetUnit.rawValue)"
        case .range:
            guard let min = target.min, let max = target.max else { return "" }
            return " @ \(formatPace(convertPace(min, from: sourceUnit, to: targetUnit)))-\(formatPace(convertPace(max, from: sourceUnit, to: targetUnit)))/\(targetUnit.rawValue)"
        }
    }

    private static func orderedRange(_ values: [Double]) -> (lower: Double, upper: Double) {
        (min(values[0], values[1]), max(values[0], values[1]))
    }

    private static func onlyDigits<S: StringProtocol>(_ value: S) -> String {
        String(value.filter(\.isWholeNumber))
    }

    private static func formatCleanNumber(_ value: Double) -> String {
        value.rounded() == value ? String(Int(value)) : String(format: "%.2f", value)
    }
}
