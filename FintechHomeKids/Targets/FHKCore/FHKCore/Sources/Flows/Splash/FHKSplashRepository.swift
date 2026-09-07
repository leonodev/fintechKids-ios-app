//
//  FHKSplashRepository.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 25/8/26.
//

import Foundation
import FLibInjections

public struct FHKSplashRepository: Sendable {
    public var readLanguageCurrent: @Sendable () async throws -> String? = { nil }
    
    public init() {}
}

public extension DependenciesInjection {
    var fhkSplashRepository: FHKSplashRepository {
        get { get(FHKSplashRepository.self, preview: .preview, testing: .test) }
        set { set(newValue, for: FHKSplashRepository.self) }
    }
}

#if DEBUG
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

#endif
