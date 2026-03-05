//
//  BadgeStyleModifier.swift
//  Iterly
//
//  Created by Filippo Cilia on 02/03/2026.
//

import SwiftUI

private struct BadgeStyleModifier: ViewModifier {
    let backgroundColor: Color

    func body(content: Content) -> some View {
        content
            .textCase(.uppercase)
            .foregroundStyle(.primary)
            .font(.caption2)
            .bold()
            .contentTransition(.numericText())
            .padding(4)
            .background(backgroundColor.opacity(0.5))
            .clipShape(.rect(cornerRadius: 4, style: .continuous))
    }
}

extension View {
    func badgeStyle(backgroundColor: Color) -> some View {
        modifier(BadgeStyleModifier(backgroundColor: backgroundColor))
    }
}
