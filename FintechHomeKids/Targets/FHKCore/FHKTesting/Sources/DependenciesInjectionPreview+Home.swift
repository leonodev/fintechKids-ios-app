//
//  DependenciesInjectionPreview+Home.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import Foundation
import FLibInjections
import FHKCore
import FHKDomain

public extension DependenciesInjection {
    
    // It only records what lives natively in Feature Home
    static func registerHomePreview() {
        inject.registerMock(FHKHomeRepository.self,
                            preview: { .preview },
                            testing: { .test })
        
        
        inject.registerMock(FHKMembers.self,
                            preview: { .preview },
                            testing: { .test })
        
        inject.registerMock(FHKGoal.self,
                            preview: { .preview },
                            testing: { .test})
        
    }
}
