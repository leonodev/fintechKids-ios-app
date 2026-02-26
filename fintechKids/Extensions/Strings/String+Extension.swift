//
//  String+Extension.swift
//  fintechKids
//
//  Created by Fredy Leon on 25/12/25.
//

import Foundation
import SwiftUI
import FHKInjections
import FHKDesignSystem
import FHKDomain

public extension String {
    func localized() -> String {
        
        var bundle: Bundle {
            inject.languageManager.currentBundle
        }
        return bundle.localizedString(forKey: self, value: nil, table: "Localizable")
    }
    
    var languageTypeToImageFlag: Image {
        switch self {
        case LanguageType.it.code(): return .italyCircleFlag
        case LanguageType.en.code(): return .englandCircleFlag
        case LanguageType.fr.code(): return .franceCircleFlag
        default: return .spainCircleFlag
        }
    }
}
