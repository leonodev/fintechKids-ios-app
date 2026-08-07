//
//  BlinkSkeletonModifier.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 22/4/26.
//

import SwiftUI

struct BlinkCircleSkeletonModifier: ViewModifier {
    @State private var isPulsing: Bool = false
    var color: Color = .gray
    var lineWidth: CGFloat = 2
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: lineWidth)
            )
            .opacity(isPulsing ? 0.5 : 1.0)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                    isPulsing = true
                }
            }
    }
}

extension View {
    func blinkCircleSkeleton(color: Color = .gray, lineWidth: CGFloat = 2) -> some View {
        self.modifier(BlinkCircleSkeletonModifier(color: color, lineWidth: lineWidth))
    }
}
