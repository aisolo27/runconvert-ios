import Testing
@testable import RunningAppConverterFeature

struct DurationEntryTests {
    @Test(arguments: [
        ("", "25", "", 1_500, "25:00"),
        ("1", "35", "00", 5_700, "1:35:00"),
        ("", "", "25", 25, "0:25"),
        ("2", "", "", 7_200, "2:00:00"),
        ("0", "02", "00", 120, "2:00")
    ])
    func explicitComponentsHaveUnambiguousMeaning(_ input: (String, String, String, Int, String)) {
        let entry = DurationEntry(hours: input.0, minutes: input.1, seconds: input.2)
        #expect(entry.totalSeconds == input.3)
        #expect(entry.clock == input.4)
    }

    @Test(arguments: [
        DurationEntry(), DurationEntry(minutes: "0"), DurationEntry(minutes: "135"),
        DurationEntry(seconds: "60"), DurationEntry(minutes: "-1"), DurationEntry(hours: "1.5"),
        DurationEntry(hours: "1000000"), DurationEntry(hours: "999999999999999999999"),
        DurationEntry(minutes: "abc"), DurationEntry(seconds: "45:72")
    ])
    func malformedOrNonpositiveTimesAreRejected(_ entry: DurationEntry) {
        #expect(entry.totalSeconds == nil)
        #expect(entry.clock == nil)
    }

    @Test(arguments: DurationEntry.Component.allCases)
    func pastingACompleteClockDoesNotFlattenItsDigits(_ component: DurationEntry.Component) {
        var entry = DurationEntry()
        entry.update("1:35:00", component: component)
        #expect(entry.totalSeconds == 5_700)
        #expect(entry.hours == "1")
        #expect(entry.minutes == "35")
        #expect(entry.seconds == "00")
    }

    @Test func recoveryDefaultsAndLongMinuteClocksKeepTheirMeaning() {
        #expect(DurationEntry(clock: "02:00")?.totalSeconds == 120)
        #expect(DurationEntry(clock: "135:00")?.totalSeconds == 8_100)
        #expect(DurationEntry(clock: "135:00")?.clock == "2:15:00")
        #expect(DurationEntry(clock: "45:72") == nil)
        #expect(DurationEntry(clock: "1:60:00") == nil)
    }

    @Test func pastedNegativeOrMalformedPaceIsNotSilentlyMadePositive() {
        #expect(RunningConversions.cleanDecimalInput("-1") == "-1")
        #expect(RunningConversions.parseDistance(RunningConversions.cleanDecimalInput("-1")) == nil)
        #expect(RunningConversions.sanitizePaceInput("-500") == "-500")
        #expect(RunningConversions.parseFlexiblePaceToSeconds("-500") == nil)
        #expect(RunningConversions.parseFlexiblePaceToSeconds("5.5") == nil)
        #expect(RunningConversions.parseTargetTimeToSeconds("abc25") == nil)
    }
}
