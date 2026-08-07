//
//  IntegerOnlyModifier.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 14/3/26.
//

import SwiftUI

public struct IntegerOnlyModifier: ViewModifier {
    @Binding var text: String

    public func body(content: Content) -> some View {
        content
            .keyboardType(.numberPad)
            .onChange(of: text) { _, newValue in
                let filtered = newValue.filter { "0123456789".contains($0) }
                if filtered != newValue {
                    text = filtered
                }
            }
    }
}

public extension View {
    /// Fuerza a que un TextField solo acepte números enteros.
    public func onlyIntegers(text: Binding<String>) -> some View {
        self.modifier(IntegerOnlyModifier(text: text))
    }
}
