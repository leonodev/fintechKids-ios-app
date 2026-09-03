//
//  FHKDIKeyPathDeclare.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 1/9/26.
//

import Foundation
import FLibStorage
import FLibInjections
import FHKCore

public extension DependenciesInjection {
    
    var fhkSplashRepository: FHKSplashRepository {
        get { inject.get(FHKSplashRepository.self) }
        set { inject.set(newValue, for: FHKSplashRepository.self) }
    }
    
    var fhkLanguageRepository: FHKLanguageRepository {
        get { inject.get(FHKLanguageRepository.self) }
        set { inject.set(newValue, for: (FHKLanguageRepository).self) }
    }
    
    var fhkAuth: FHKAuth {
        get { inject.get(FHKAuth.self) }
        set { inject.set(newValue, for: FHKAuth.self) }
    }
    
    var fhkSession: FHKSession {
        get { inject.get(FHKSession.self) }
        set { inject.set(newValue, for: FHKSession.self) }
    }
    
    var fhkLanguage: FHKLanguage {
        get { inject.get(FHKLanguage.self) }
        set { inject.set(newValue, for: FHKLanguage.self) }
    }
    
    var fhkAnalitycs: FHKAnalytics {
        get { inject.get(FHKAnalytics.self) }
        set { inject.set(newValue, for: FHKAnalytics.self) }
    }
    
    var fhkFirebaseRemoteConfig: FHKRemoteConfig {
        get { inject.get(FHKRemoteConfig.self) }
        set { inject.set(newValue, for: FHKRemoteConfig.self) }
    }  
}
