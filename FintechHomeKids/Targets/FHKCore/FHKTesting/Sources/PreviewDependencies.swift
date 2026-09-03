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
        DependenciesInjection.registerAuthPreview()
        DependenciesInjection.registerCorePreview()
        DependenciesInjection.registerDesignSystemPreview()
        DependenciesInjection.registerInfrastructurePreview()
        DependenciesInjection.registerAppPreview()
        #endif
    }
}
