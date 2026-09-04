//
//  DependenciesInjection+FHKAuth.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 3/9/26.
//

import Foundation
import FLibInjections
import FHKCore
import FHKDomain

public extension DependenciesInjection {
    
    var fhkSplashRepository: FHKSplashRepository {
        get { get(FHKSplashRepository.self) }
        set { set(newValue, for: FHKSplashRepository.self) }
    }
    
    var fhkLanguageRepository: FHKLanguageRepository {
        get { get(FHKLanguageRepository.self) }
        set { set(newValue, for: FHKLanguageRepository.self) }
    }
    
    var fhkLoginRepository: FHKLoginRepository {
        get { get(FHKLoginRepository.self) }
        set { set(newValue, for: FHKLoginRepository.self) }
    }
    
    var fhkRegisterRepository: FHKRegisterRepository {
        get { get(FHKRegisterRepository.self) }
        set { set(newValue, for: FHKRegisterRepository.self) }
    }
    
    // It only records what lives natively in Feature Auth
    static func registerAuthFeature() {
        inject.fhkSplashRepository = .live
        inject.fhkLanguageRepository = .live
        inject.fhkConfiguration = .live
        inject.fhkLoginRepository = .live
        inject.fhkRegisterRepository = .live
    }
}
