//
//  DependenciesInjection+Core.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 3/9/26.
//

import Foundation
import FLibStorage
import FLibInjections

public extension DependenciesInjection {
    
    // KeyPaths for the entire app
    var fhkEnvironment: FHKEnvironment {
        get { inject.get(FHKEnvironment.self) }
        set { inject.set(newValue, for: FHKEnvironment.self) }
    }
    
    var fhkStorage: FHKStorageManager {
        get { inject.get(FHKStorageManager.self) }
        set { inject.set(newValue, for: FHKStorageManager.self) }
    }
    
    var fhkSecurity: FHKSecurity {
        get { inject.get(FHKSecurity.self) }
        set { inject.set(newValue, for: FHKSecurity.self) }
    }
    
    // It only records what lives natively in Core
    static func registerCore() {
        inject.fhkEnvironment = .live
    }
}
