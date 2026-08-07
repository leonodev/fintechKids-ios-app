//
//  BlinkTextSkeletonModifier.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 22/4/26.
//

import SwiftUI

struct BlinkTextSkeletonModifier: ViewModifier {
    @State private var isPulsing: Bool = false
    var color: Color = .gray
    var lineWidth: CGFloat = 2
    
    func body(content: Content) -> some View {
        content
            .opacity(isPulsing ? 0.5 : 1.0)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                    isPulsing = true
                }
            }
    }
}

extension View {
    func blinkTextSkeleton(color: Color = .gray, lineWidth: CGFloat = 2) -> some View {
        self.modifier(BlinkTextSkeletonModifier(color: color, lineWidth: lineWidth))
    }
}
