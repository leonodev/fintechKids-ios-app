//
//  SplashRepository.swift
//  fintechKids
//
//  Created by Fredy Leon on 1/3/26.
//

import FHKDomain
import FHKInjections
import FHKStorage

final class SplashRepository: FHKSplashRepositoryProtocol {
    
    // Properties Injected
    private var fhkStorage: any FHKStorageManagerProtocol {
        inject.fhkStorage
    }
    
    func readLanguageCurrent() async throws -> String? {
        try await fhkStorage.readUserDefaults(String.self,
                                              forKey: UserDefaultsKeys.languageKey)
    }
}
