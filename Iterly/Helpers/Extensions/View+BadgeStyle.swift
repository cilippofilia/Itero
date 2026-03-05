//
//  BadgeStyleModifier.swift
//  Iterly
//
//  Created by Filippo Cilia on 02/03/2026.
//

import SwiftUI

private struct BadgeStyleModifier: ViewModifier {
    @Environment(\.self) private var environment
    let backgroundColor: Color

    func body(content: Content) -> some View {
        content
            .textCase(.uppercase)
            .foregroundStyle(foregroundColor)
            .font(.caption2)
            .bold()
            .contentTransition(.numericText())
            .padding(4)
            .background(backgroundColor.gradient)
            .clipShape(.rect(cornerRadius: 4, style: .continuous))
    }

    private var foregroundColor: Color {
        let resolved = backgroundColor.resolve(in: environment)
        let luminance = (0.2126 * resolved.red) + (0.7152 * resolved.green) + (0.0722 * resolved.blue)
        return luminance < 0.6 ? .white : .black
    }
}

extension View {
    func badgeStyle(backgroundColor: Color) -> some View {
        modifier(BadgeStyleModifier(backgroundColor: backgroundColor))
    }
}
