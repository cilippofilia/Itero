//
//  Priority-Enums.swift
//  Iterly
//
//  Created by Filippo Cilia on 01/03/2026.
//

import SwiftUI

enum ProjectPriority: String, CaseIterable, Codable {
    static let `default` = Self.notSet

    case notSet
    case low
    case medium
    case high

    var title: String {
        switch self {
        case .notSet:
            "Not Set"
        case .low:
            "Low"
        case .medium:
            "Medium"
        case .high:
            "High"
        }
    }

    var backgroundColor: Color {
        switch self {
        case .notSet:
            return .secondary
        case .low:
            return .blue
        case .medium:
            return .yellow
        case .high:
            return .red
        }
    }
}

enum TaskPriority: String, CaseIterable, Codable {
    static let `default` = Self.notSet

    case notSet
    case low
    case medium
    case high

    var title: String {
        switch self {
        case .notSet:
            "Not Set"
        case .low:
            "Low"
        case .medium:
            "Medium"
        case .high:
            "High"
        }
    }

    var backgroundColor: Color {
        switch self {
        case .notSet:
            return .secondary
        case .low:
            return .blue
        case .medium:
            return .yellow
        case .high:
            return .orange
        }
    }
}
