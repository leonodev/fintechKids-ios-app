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
    func localized() -> String {
        
        var bundle: Bundle {
            inject.fhkLanguage.currentBundle()
        }
        return bundle.localizedString(forKey: self, value: nil, table: "Localizable")
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
