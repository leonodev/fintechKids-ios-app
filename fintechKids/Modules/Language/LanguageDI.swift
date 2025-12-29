//
//  LanguageDI.swift
//  fintechKids
//
//  Created by Fredy Leon on 29/12/25.
//

import Foundation
import FHKCore
import FHKUtils
import FHKConfig
import FHKInjections

public extension DependenciesInjection {
    
    var languageManager: any LanguageManagerProtocol {
        get { self[(any LanguageManagerProtocol).self] }
        set { self[(any LanguageManagerProtocol).self] = newValue }
    }
}
