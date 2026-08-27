//
//  VisualEffectView.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 26/1/26.
//

import SwiftUI
import UIKit

public struct VisualEffectView: UIViewRepresentable {
    private var effect: UIVisualEffect?
    
    public init(effect: UIVisualEffect? = nil) {
        self.effect = effect
    }

    public func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: effect)
    }
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
