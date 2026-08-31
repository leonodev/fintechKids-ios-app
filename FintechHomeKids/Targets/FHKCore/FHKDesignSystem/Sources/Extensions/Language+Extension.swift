//
//  Language+Extension.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 30/8/26.
//

import Foundation
import SwiftUI
import FHKCore

public extension String {
    
    @MainActor
    func localized(
            _ bundle: Bundle? = nil,
            table: String = "Localizable",
            comment: String = ""
        ) -> String {
            
            let baseBundle = bundle ?? .module
            
            let currentLanguage = inject.fhkLanguage.selectedLanguage()
            
            let targetBundle: Bundle
            if let path = baseBundle.path(forResource: currentLanguage, ofType: "lproj"),
               let langBundle = Bundle(path: path) {
                targetBundle = langBundle
            } else {
                targetBundle = baseBundle
            }
            
            return targetBundle.localizedString(forKey: self, value: self, table: table)
        }
    
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    var languageTypeToImageFlag: Image {
        switch self {
        case LanguageType.it.code: return .italyCircleFlag
        case LanguageType.en.code: return .englandCircleFlag
        case LanguageType.fr.code: return .franceCircleFlag
        default: return .spainCircleFlag
        }
    }
}
