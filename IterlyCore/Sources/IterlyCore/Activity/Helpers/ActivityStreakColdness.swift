//
//  ActivityStreakColdness.swift
//  IterlyCore
//
//  Created by Filippo Cilia on 08/08/2026.
//

import Foundation

/// How far a streak's flame has "cooled" through the day when nothing's been logged yet:
/// 0 when fully lit (already logged today, or the streak isn't active), ramping up in four
/// six-hourly steps toward — but never reaching — fully cold, so an active-but-unlogged
/// streak always reads as still-alive. Only a truly lapsed streak (1) goes fully cold.
/// Shared by every widget family that wants to reflect the passing of the day.
public enum ActivityStreakColdness {
    public static func value(
        isActiveStreak: Bool,
        hasLoggedToday: Bool,
        date: Date,
        calendar: Calendar = .autoupdatingCurrent
    ) -> Double {
        guard isActiveStreak else { return 1 }
        guard !hasLoggedToday else { return 0 }

        let hour = calendar.component(.hour, from: date)
        let sixHourStep = hour / 6
        return Double(sixHourStep) / 4
    }
}
