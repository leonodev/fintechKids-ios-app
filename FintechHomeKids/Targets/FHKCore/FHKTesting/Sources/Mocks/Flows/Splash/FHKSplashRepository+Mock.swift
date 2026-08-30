//
//  FHKSplashRepository+Mock.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 30/8/26.
//

import Foundation
import FHKCore

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
