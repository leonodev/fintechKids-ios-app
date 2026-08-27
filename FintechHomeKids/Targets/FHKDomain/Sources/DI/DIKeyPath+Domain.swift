//
//  DIKeyPath+Domain.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 27/8/26.
//

import FLibInjections
import FLibStorage

public extension DependenciesInjection {
    
    var fhkSplashRepository: FHKSplashRepository {
        get { get(FHKSplashRepository.self) }
        set { set(newValue, for: FHKSplashRepository.self) }
    }
}
