//
//  LanguageModifier.swift
//  fintechKids
//
//  Created by Fredy Leon on 29/12/25.
//

import SwiftUI
import FHKInjections
import FHKDomain

public struct LanguageObserverModifier: ViewModifier {
    
    // Injections Dependency
    private var fhkLanguage: any FHKLanguageManagerProtocol {
        inject.fhkLanguage
    }

    public func body(content: Content) -> some View {
        let currentLanguage = fhkLanguage.selectedLanguage
        
        content
            .environment(\.locale, .init(identifier: currentLanguage))
    }
}

public extension View {
    func observeLanguage() -> some View {
        self.modifier(LanguageObserverModifier())
    }
}
