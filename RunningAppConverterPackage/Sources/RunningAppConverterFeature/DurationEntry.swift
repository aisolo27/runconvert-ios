import Foundation

/// Explicit components keep an entered 1 hour 35 minutes distinct from 135 minutes
/// or the old compact-digit interpretation of 1 minute 35 seconds.
struct DurationEntry: Equatable, Hashable {
    enum Component: String, CaseIterable {
        case hours, minutes, seconds

        var title: String { rawValue.capitalized }
        var placeholder: String {
            switch self {
            case .hours: "hh"
            case .minutes: "mm"
            case .seconds: "ss"
            }
        }
    }

    var hours = ""
    var minutes = ""
    var seconds = ""

    subscript(component: Component) -> String {
        get {
            switch component {
            case .hours: hours
            case .minutes: minutes
            case .seconds: seconds
            }
        }
        set {
            switch component {
            case .hours: hours = newValue
            case .minutes: minutes = newValue
            case .seconds: seconds = newValue
            }
        }
    }

    mutating func update(_ text: String, component: Component) {
        // A complete clock pasted into any component distributes its parts. Never
        // strip its colons into a large number of hours or minutes.
        if text.contains(":"), let pasted = Self(clock: text) {
            self = pasted
        } else {
            self[component] = text.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }

    init(hours: String = "", minutes: String = "", seconds: String = "") {
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
    }

    init?(clock: String) {
        let parts = clock.trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: ":", omittingEmptySubsequences: false).map(String.init)
        guard (2...3).contains(parts.count), parts.allSatisfy({ !$0.isEmpty && $0.allSatisfy(\.isASCIIWholeNumber) }) else { return nil }
        if parts.count == 2 {
            guard let totalMinutes = Int(parts[0]), totalMinutes <= 59_999_999 else { return nil }
            self.init(hours: totalMinutes >= 60 ? String(totalMinutes / 60) : "", minutes: String(totalMinutes % 60), seconds: parts[1])
        } else {
            self.init(hours: parts[0], minutes: parts[1], seconds: parts[2])
        }
        guard validationMessage == nil else { return nil }
    }

    var isEmpty: Bool { hours.isEmpty && minutes.isEmpty && seconds.isEmpty }

    var validationMessage: String? {
        for component in Component.allCases where !self[component].isEmpty {
            guard self[component].allSatisfy(\.isASCIIWholeNumber), Int(self[component]) != nil else {
                return "Use digits in \(component.title), or paste a complete hh:mm:ss time."
            }
        }
        // Match the existing clock parser's six-digit hour limit and avoid overflow.
        guard (Int(hours) ?? 0) <= 999_999 else { return "Hours is too large." }
        guard (Int(minutes) ?? 0) <= 59 else { return "Minutes must be 0–59. Put whole hours in Hours." }
        guard (Int(seconds) ?? 0) <= 59 else { return "Seconds must be 0–59." }
        if !isEmpty, rawSeconds == 0 { return "Enter a time greater than zero." }
        return nil
    }

    var totalSeconds: Int? {
        guard !isEmpty, validationMessage == nil, rawSeconds > 0 else { return nil }
        return rawSeconds
    }

    var clock: String? {
        totalSeconds.map { RunningConversions.formatTime(Double($0)) }
    }

    var description: String? {
        guard totalSeconds != nil else { return nil }
        let values = [(Int(hours) ?? 0, "hr"), (Int(minutes) ?? 0, "min"), (Int(seconds) ?? 0, "sec")]
        return values.filter { $0.0 > 0 }.map { "\($0.0) \($0.1)" }.joined(separator: " ")
    }

    private var rawSeconds: Int {
        // The validated ranges above bound this calculation well below Int.max.
        guard let h = Int(hours.isEmpty ? "0" : hours), h <= 999_999,
              let m = Int(minutes.isEmpty ? "0" : minutes), m <= 59,
              let s = Int(seconds.isEmpty ? "0" : seconds), s <= 59 else { return 0 }
        return h * 3_600 + m * 60 + s
    }
}

private extension Character {
    var isASCIIWholeNumber: Bool { ("0"..."9").contains(self) }
}
