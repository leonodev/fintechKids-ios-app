//
//  DependenciesInjectionPreview+FHKDesignSystem.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 3/9/26.
//

import Foundation
import FLibInjections
import FHKCore
import FHKDomain

public extension DependenciesInjection {
    
    // It only records what lives natively in DesignSystem
    @MainActor
    static func registerDesignSystemPreview() {
        inject.registerMock(FHKModal.self,
                        preview: { .preview },
                        testing: { .test }
        )  
    }
}
