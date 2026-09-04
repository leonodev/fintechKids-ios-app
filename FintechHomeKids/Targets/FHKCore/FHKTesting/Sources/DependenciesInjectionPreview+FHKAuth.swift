//
//  DependenciesInjectionPreview+FHKAuth.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 3/9/26.
//

import Foundation
import FLibInjections
import FHKCore
import FHKDomain

public extension DependenciesInjection {
    
    // It only records what lives natively in Feature Auth
    static func registerAuthPreview() {
        inject.registerMock(FHKSplashRepository.self,
                            preview: { .preview },
                            testing: { .test })
                            
        inject.registerMock(FHKLanguageRepository.self,
                            preview: { .preview },
                            testing: { .test }
        )
        
        inject.registerMock(FHKRegisterRepository.self,
                            testing: { .test }
        )
    }
}
