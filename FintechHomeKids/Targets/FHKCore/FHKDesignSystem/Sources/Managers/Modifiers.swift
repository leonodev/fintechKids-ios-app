//
//  Modifiers.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 2/12/25.
//

// Extensión de View en lugar de función libre

import SwiftUI

public struct BackgroundDemoModifier: ViewModifier {
    
    public func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Image.backgroundDemo
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            }
            //.ignoresSafeArea()
    }
}

extension View {
    public func applyBackgroundDemoModifier() -> some View {
        self.modifier(BackgroundDemoModifier())
    }
}


