//
//  FHKSplashRepository.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 25/8/26.
//

import Foundation
import FLibInjections
import FHKCore

public struct FHKSplashRepository: Sendable {
    public var readLanguageCurrent: @Sendable () async throws(FHKAppError) -> String? = { nil }
    public var checkVersion: @Sendable () async throws(FHKAppError) -> FHKAppVersionEntity? = { nil }
    
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
        
        repository.checkVersion = {
            FHKAppVersionEntity(platform: "IOS",
                                currentVersion: "1.0.0",
                                latestVersion: "1.2.0",
                                minRequiredVersion: "1.0.0",
                                isUpToDate: false,
                                updateAvailable: true,
                                forceUpdate: false,
                                storeUrl: "https://apps.apple.com/app/id000000000",
                                releaseNotes: "Performance improvements and new security features.",
                                message: "A new version (1.2.0) is available in the store.")
        }
        
        return repository
    }
    
    static var preview: Self {
        var repository = Self()
        
        repository.readLanguageCurrent = { "en" }
        
        repository.checkVersion = {
            FHKAppVersionEntity(platform: "IOS",
                                currentVersion: "1.0.0",
                                latestVersion: "1.2.0",
                                minRequiredVersion: "1.0.0",
                                isUpToDate: false,
                                updateAvailable: true,
                                forceUpdate: false,
                                storeUrl: "https://apps.apple.com/app/id000000000",
                                releaseNotes: "Performance improvements and new security features.",
                                message: "A new version (1.2.0) is available in the store.")
        }
        
        return repository
    }
}

#endif
