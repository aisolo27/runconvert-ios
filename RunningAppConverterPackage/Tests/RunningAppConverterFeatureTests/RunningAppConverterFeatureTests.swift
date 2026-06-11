import Foundation
import Testing
@testable import RunningAppConverterFeature

@Test func distanceConversionMatchesWebAppConstants() {
    #expect(RunningConversions.formatDistance(RunningConversions.convertDistance(10, from: DistanceUnit.km, to: DistanceUnit.mi)) == "6.21")
    #expect(RunningConversions.formatDistance(RunningConversions.convertDistance(6.21, from: DistanceUnit.mi, to: DistanceUnit.km)) == "9.99")
}

@Test func paceParsingSupportsColonAndShorthandInput() {
    #expect(RunningConversions.parseFlexiblePaceToSeconds("7:40") == 460)
    #expect(RunningConversions.parseFlexiblePaceToSeconds("605") == 365)
    #expect(RunningConversions.sanitizePaceInput("740") == "7:40")
}

@Test func paceConversionRoundsToNearestSecond() {
    let converted = RunningConversions.convertPace(300, from: .km, to: .mi)
    #expect(RunningConversions.formatPace(converted) == "8:03")
}

@Test func timeEstimateAndTargetPaceMatchExpectedRunningMath() {
    #expect(RunningConversions.estimateTime(distance: 10, paceSeconds: 300) == "50:00")
    #expect(RunningConversions.targetPace(distance: 5, targetTimeSeconds: 1_200) == "4:00")
}

@Test func workoutSummaryConvertsNormalRunDistanceAndPace() throws {
    let pace = PaceTarget(mode: .range, min: 360, max: 390)
    let config = NormalRunConfig(distance: 8, unit: .km, paceTarget: pace)
    let summary = RunningConversions.buildNormalRunSummary(config, sourceUnit: .km, targetUnit: .mi)

    #expect(RunningConversions.calculateNormalRunTotalDistance(config, targetUnit: .mi) == 4.97)
    #expect(summary == ["Normal Run: 4.97 mi @ 9:39-10:28/mi"])
}

@Test func intervalTotalsIncludeMetersInsideRepeatBlocks() throws {
    let warmup = IntervalSection(
        id: UUID(),
        role: .warmup,
        label: "Warm-up",
        goalType: .distance,
        distance: 1,
        unit: .km,
        paceTarget: PaceTarget(mode: .none)
    )
    let work = IntervalSection(
        id: UUID(),
        role: .work,
        label: "Work",
        goalType: .distance,
        distance: 400,
        unit: .m,
        paceTarget: PaceTarget(mode: .value, unit: .km, value: 270)
    )
    let recovery = IntervalSection(
        id: UUID(),
        role: .recovery,
        label: "Recovery",
        goalType: .time,
        duration: "02:00",
        paceTarget: PaceTarget(mode: .none)
    )
    let cooldown = IntervalSection(
        id: UUID(),
        role: .cooldown,
        label: "Cool-down",
        goalType: .open,
        paceTarget: PaceTarget(mode: .none)
    )
    let config = IntervalsConfig(
        warmup: warmup,
        blocks: [RepeatBlock(id: UUID(), repeatCount: 5, steps: [work, recovery])],
        cooldown: cooldown
    )

    #expect(RunningConversions.calculateIntervalsTotalDistance(config, targetUnit: .km) == 3.0)
}
