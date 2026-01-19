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
import FHKDesignSystem

public class Dependencies {
    
    static func registerAll() {
        let deps = DependenciesInjection.shared
        
        // implementatios to inject here
        
        /// Language
        deps.set(LanguageManager.shared, for: (any LanguageManagerProtocol).self)
        
        /// Camera Permission
        deps.set(CameraPermissionService(), for: PermissionProtocol.self)
        
        /// Toast
        deps.set(ToastService(), for: ToastServiceProtocol.self)
        Logger.info("All dependencies registered successfully")
    }
}
