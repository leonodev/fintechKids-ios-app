//
//  DIKeyPath+Domain.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 27/8/26.
//

import FLibInjections
import FHKCore

public extension DependenciesInjection {
    
    var fhkSplashRepository: FHKSplashRepository {
        get { get(FHKSplashRepository.self) }
        set { set(newValue, for: FHKSplashRepository.self) }
    }
    
    var fhkLanguageRepository: FHKLanguageRepository {
        get { get(FHKLanguageRepository.self) }
        set { set(newValue, for: (FHKLanguageRepository).self) }
    }
    
    var fhkAuth: FHKAuth {
        get { get(FHKAuth.self) }
        set { set(newValue, for: FHKAuth.self) }
    }
}
