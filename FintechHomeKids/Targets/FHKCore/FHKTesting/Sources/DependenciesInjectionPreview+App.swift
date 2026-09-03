//
//  DependenciesInjectionPreview+App.swift
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
    
    // It only records what lives natively in Main App
    static func registerAppPreview() {
        
        inject.registerMock(FHKSession.self,
                        testing: { .test }
        )

        inject.registerMock(FHKRemoteConfig.self,
                            preview: { .preview },
                            testing: { .test }
        )
        
        inject.registerMock(FHKAnalytics.self,
                            preview: { .preview },
                            testing: { .test }
        )
        
        inject.registerMock(FHKAuth.self,
                            testing: { .test }
        )
    }
}
