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
        let configuration = inject.fhkConfiguration
        var repository = Self()

        repository.readLanguageCurrent = { () throws(FHKAppError) in
            try await storage.readDefaults(String.self, forKey: UserDefaultsKeys.languageKey)
        }
        
        repository.checkVersion = { () throws(FHKAppError) in
            let responseDto: FHKAppVersionDto = try await FHKAPI.Builder()
                            .setPath(.appVersion)
                            .setMethod(.GET)
                            .setUrlParams([
                                "platform": "IOS",
                                "current_version": configuration.versionAPP()
                            ])
                            .build()
                            .execute()
            
            return responseDto.toDomain()
        }

        return repository
    }
}
