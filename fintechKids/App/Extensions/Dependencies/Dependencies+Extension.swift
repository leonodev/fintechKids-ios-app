//
//  Dependencies+Extension.swift
//  fintechKids
//
//  Created by Fredy Leon on 29/12/25.
//

import Foundation
import FHKInjections
import FHKUtils
import FHKConfig

public class Dependencies {
    
    static func registerAll() {
        let deps = DependenciesInjection.shared
        
        // implementatios to inject here
        deps.set(LanguageManager.shared, for: (any LanguageManagerProtocol).self)

        
        Logger.info("All dependencies registered successfully")
    }
}
