//
//  LanguageObserverModifier.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 27/8/26.
//

import SwiftUI
import FHKCore

public struct FHKLanguageObserverModifier: ViewModifier {
    
    // Injections Dependency
    private var fhkLanguage: FHKLanguage {
        inject.fhkLanguage
    }

    public func body(content: Content) -> some View {
        let currentLanguage = fhkLanguage.selectedLanguage()
        
        content
            .environment(\.locale, .init(identifier: currentLanguage))
            .id(currentLanguage)
    }
}

public extension View {
    func observeLanguage() -> some View {
        self.modifier(FHKLanguageObserverModifier())
    }
}
