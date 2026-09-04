//
//  DependenciesInjection+Domain.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 4/9/26.
//

import Foundation
import FHKCore
import FLibInjections

public extension DependenciesInjection {
    
    // KeyPaths for the entire app
    var fhkAuth: FHKAuth {
        get { get(FHKAuth.self) }
        set { set(newValue, for: FHKAuth.self) }
    }
    
    var fhkConfiguration: FHKConfiguration {
        get { get(FHKConfiguration.self) }
        set { set(newValue, for: FHKConfiguration.self) }
    }
    
    // It only records what lives natively in Domain
    static func registerDomain() {
        
    }
}
