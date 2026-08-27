//
//  FHKSplashRepository.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 27/8/26.
//

import FHKCore
import FHKDomain
import FLibInjections
import FLibStorage

public extension FHKSplashRepository {

    static var live: Self {
        let storage = inject.fhkStorage
        var repository = Self()

        repository.readLanguageCurrent = {
            try await storage.readUserDefaults(
                String.self,
                forKey: UserDefaultsKeys.languageKey
            )
        }

        return repository
    }
}
