//
//  DependenciesRegisterModules.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 27/8/26.
//

import Foundation
import Supabase
import FLibInjections
import FLibStorage
import FHKCore
import FHKDomain

public class FHKModulesDependencies {
    
    @MainActor
    public static func register() throws {
        
        inject.register(FHKSplashRepository.self,
                        live: { .live }
        )
        
        inject.register(FHKLanguageRepository.self,
                        live: { .live }
        )
        
    }
}
