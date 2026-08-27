//
//  PreviewDependencies.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 25/8/26.
//

import Foundation
import FHKCore
import FHKDomain
import FLibInjections
import FLibStorage

public enum FHKPreviewDependencies {
    
    @MainActor
    public static func registerDefaults() {
        #if DEBUG
        registerBaseMocks()
        #endif
    }
    
    @MainActor
    private static func registerBaseMocks() {
        inject.registerMock(FHKEnvironment.self,
                            preview: { .preview }
        )
        
        inject.registerMock(FHKStorageManager.self,
                        testing: { .test }
        )
        
        inject.registerMock(FHKSession.self,
                        testing: { .test }
        )
        
        inject.registerMock(FHKModal.self,
                        preview: { .preview },
                        testing: { .test }
        )
        
        inject.registerMock(FHKSplashRepository.self,
                            preview: { .preview },
                            testing: { .test }
        )
    }
}
