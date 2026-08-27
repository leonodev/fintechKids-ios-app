//
//  LottieView.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 14/12/25.
//

import SwiftUI
import Lottie

public enum LottieLoop {
    case loop
    case playOnce
    case autoReverse
    case `repeat`(number: Float)
    case repeatBackwards(number: Float)
    
    public func mode() -> LottieLoopMode {
        switch self {
        case .loop:
            return .loop
        case .playOnce:
            return .playOnce
        case .autoReverse:
            return .autoReverse
        case let .repeat(number):
            return .repeat(number)
        case let .repeatBackwards(number):
            return .repeatBackwards(number)
        }
    }
}

public struct LottieView: UIViewRepresentable {
    let animationName: String
    var loopMode: LottieLoop
    var contentMode: UIView.ContentMode
    var identifier: String?
    
    public init(animationName: String,
                loopMode: LottieLoop = .loop,
                contentMode: UIView.ContentMode = .scaleAspectFit,
                identifier: String? = nil
    ) {
        self.animationName = animationName
        self.loopMode = loopMode
        self.contentMode = contentMode
        self.identifier = identifier
    }
    
    public func makeUIView(context: Context) -> LottieAnimationView {
        let animationView = LottieAnimationView()
        animationView.animation = LottieAnimation.named(animationName, bundle: .module)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode.mode()
        animationView.animationSpeed = 1.5
        animationView.clipsToBounds = false
        
    
        // Asegurar que la vista sea accesible
        animationView.isAccessibilityElement = true
        
        if let accessibilityIdentifier = identifier {
            animationView.accessibilityIdentifier = accessibilityIdentifier
        }
        
        // Esto hace que respete el frame de SwiftUI
        animationView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        animationView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        animationView.play()
        return animationView
    }

    public func updateUIView(_ uiView: LottieAnimationView, context: Context) {
        // Re-aplicar el identificador en updates
        if let accessibilityIdentifier = identifier {
            uiView.accessibilityIdentifier = accessibilityIdentifier
        }
    }
}
