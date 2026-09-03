//
//  DependenciesInjection+DesignSystem.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 3/9/26.
//

import Foundation
import FLibInjections
import FHKCore

public extension DependenciesInjection {
    
    var fhkModal: FHKModal {
        get { inject.get(FHKModal.self) }
        set { inject.set(newValue, for: FHKModal.self) }
    }
    
    var fhkToast: FHKToast {
        get { inject.get(FHKToast.self) }
        set { inject.set(newValue, for: FHKToast.self) }
    }
    
    // It only records what lives natively in DesignSystem
    @MainActor
    static func registerDesignSystem() {
        inject.fhkModal = .live
        inject.fhkToast = .live
    }
}
