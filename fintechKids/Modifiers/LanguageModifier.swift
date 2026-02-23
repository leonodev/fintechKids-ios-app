//
//  LanguageModifier.swift
//  fintechKids
//
//  Created by Fredy Leon on 29/12/25.
//

import SwiftUI
import FHKInjections
import FHKCore

public struct LanguageObserverModifier: ViewModifier {
    
    // Injections Dependency
    private var languageManager: any FHKLanguageManagerProtocol {
        inject.languageManager
    }

    public func body(content: Content) -> some View {
        let currentLanguage = languageManager.selectedLanguage
        
        content
            .environment(\.locale, .init(identifier: currentLanguage))
    }
}

public extension View {
    func observeLanguage() -> some View {
        self.modifier(LanguageObserverModifier())
    }
}
