//
//  FHKSplashRepository+Mock.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 27/8/26.
//

import FHKDomain

public extension FHKSplashRepository {
    static var test: Self {
        var repository = Self()
        repository.readLanguageCurrent = { "es" }
        return repository
    }
    
    static var preview: Self {
        var repository = Self()
        repository.readLanguageCurrent = { "en" }
        return repository
    }
}
