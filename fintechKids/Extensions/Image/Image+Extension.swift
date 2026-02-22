//
//  Image+Extension.swift
//  fintechKids
//
//  Created by Fredy Leon on 22/2/26.
//

import SwiftUI
import FHKConfig
import FHKDesignSystem

extension Image {
    public var imageToCode: String {
        switch self {
        case .englandCircleFlag: return LanguageType.en.code()
        case .franceCircleFlag: return LanguageType.fr.code()
        case .italyCircleFlag: return LanguageType.it.code()
        case .spainCircleFlag: return LanguageType.es.code()
        default: return ""
        }
    }
}
