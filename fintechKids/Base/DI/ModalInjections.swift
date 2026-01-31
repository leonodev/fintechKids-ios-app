//
//  ModalInjections.swift
//  fintechKids
//
//  Created by Fredy Leon on 26/1/26.
//

import FHKDesignSystem
import FHKInjections

public extension DependenciesInjection {
    
    var modalManager: any FHKModalProtocol {
        get { self[(any FHKModalProtocol).self] }
        set { self[(any FHKModalProtocol).self] = newValue }
    }
}
