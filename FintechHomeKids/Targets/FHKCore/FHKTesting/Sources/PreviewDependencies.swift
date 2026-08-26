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

public struct FHKPreviewDependencies {
    
    @MainActor
    public static func registerDefaults() {
        #if DEBUG
        // Mocks de Storage
        
        inject.register(FHKEnvironment.self,
                        live: { .live }
        )
        
        inject.register(FHKStorageManager.self,
                        testing: { .test }
        )
        
        #endif
    }
}
