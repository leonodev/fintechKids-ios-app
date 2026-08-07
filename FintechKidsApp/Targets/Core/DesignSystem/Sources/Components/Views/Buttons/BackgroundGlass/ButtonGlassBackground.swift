//
//  ButtonBackground.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 22/11/25.
//

import SwiftUI

public struct ButtonGlassBackground: View {
    let isPressed: Bool
    var gradientColors: [Color]
    
    public init(isPressed: Bool, gradientColors: [Color]) {
        self.isPressed = isPressed
        self.gradientColors = gradientColors
    }
    
    public var body: some View {
        ZStack {
            // Fondo base con gradiente
            RoundedRectangle(cornerRadius: FHKSize.size16)
                .fill(
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            // Efecto de vidrio
            RoundedRectangle(cornerRadius: FHKSize.size16)
                .fill(Color.white.opacity(0.1))
            
            // Efecto de profundidad cuando se presiona
            if isPressed {
                RoundedRectangle(cornerRadius: FHKSize.size16)
                    .fill(Color.black.opacity(0.6))
            }
        }
    }
}

