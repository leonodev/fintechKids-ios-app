//
//  CardBackgroundModifier.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 22/4/26.
//

import SwiftUI

struct CardBackgroundGlassModifier: ViewModifier {
    var cornerRadius: CGFloat = FHKSize.size20
    var backgroundColor: Color = .white
    var opacity: Double = 0.1
    var strokeOpacity: Double = 0.2
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor.opacity(opacity))
                    .background(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(.white.opacity(strokeOpacity), lineWidth: 1)
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}


extension View {
    func cardBackgroundGlassStyle(
        color: Color = .white,
        cornerRadius: CGFloat = FHKSize.size20
    ) -> some View {
        self.modifier(CardBackgroundGlassModifier(cornerRadius: cornerRadius, backgroundColor: color))
    }
}
