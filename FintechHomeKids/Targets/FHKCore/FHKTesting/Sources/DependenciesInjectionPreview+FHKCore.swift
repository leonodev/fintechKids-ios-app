//
//  DependenciesInjectionPreview+FHKCore.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 3/9/26.
//

import Foundation
import FLibInjections
import FHKCore
import FHKDomain

public extension DependenciesInjection {
    
    // It only records what lives natively in Core
    static func registerCorePreview() {
        inject.registerMock(FHKEnvironment.self,
                            preview: { .preview }
        )
        
        inject.registerMock(FHKLanguage.self,
                            preview: { .preview(.en) },
                            testing: { .test }
        )
    }
}
