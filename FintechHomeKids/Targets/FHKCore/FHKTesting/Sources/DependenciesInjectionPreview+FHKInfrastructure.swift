//
//  DependenciesInjectionPreview+FHKInfrastructure.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 3/9/26.
//

import Foundation
import FLibInjections
import FLibStorage
import FHKCore
import FHKDomain

public extension DependenciesInjection {
    
    // It only records what lives natively in Infrastructure
    static func registerInfrastructurePreview() {
        
        inject.registerMock(FHKStorageManager.self,
                        testing: { .test }
        )
        
        inject.registerMock(FHKSecurity.self,
                            testing: { .test }
        )
    }
}
