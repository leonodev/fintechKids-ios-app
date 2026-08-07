//
//  ColorDegradedModifier.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 22/4/26.
//

import SwiftUI

struct ColorDegradedModifier: ViewModifier {
    var startColor: Color
    var endColor: Color
    var rotation: Double = -25
    var opacity: Double = 0.9
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(
                LinearGradient(
                    colors: [startColor, endColor],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .opacity(opacity)
    }
}

public extension View {
    /// Aplica un estilo de degradado inclinado ideal para iconos de recompensas o tickets.
    public func colorDegradeStyle(
        startColor: Color = FHKColor.yellow,
        endColor: Color = FHKColor.warning,
        rotation: Double = -25
    ) -> some View {
        self.modifier(ColorDegradedModifier(startColor: startColor, endColor: endColor, rotation: rotation))
    }
}
