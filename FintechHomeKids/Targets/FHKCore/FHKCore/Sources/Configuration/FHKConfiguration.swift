//
//  FHKConfiguration.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 4/9/26.
//

import Foundation
import FLibInjections

public struct FHKConfiguration: Sendable {
    public var parentMail: @Sendable() -> String? = { nil }
    public var familyName: @Sendable() -> String? = { nil }
    public var approvePin: @Sendable() -> String? = { nil }
    
    public var refreshParentMail: @Sendable() -> Void = { }
    public var refreshFamilyName: @Sendable() -> Void = { }
    public var setEnvironment: @Sendable(FHKEnvironmentType) -> Void = { _ in }
    public var getEnvironment: @Sendable() -> FHKEnvironmentType = { .current }
    public var accessToken: @Sendable() -> String? = { nil }
    public var refreshToken: @Sendable() -> String? = { nil }
    public var deleteTokens: @Sendable() throws -> Void = { }
    public var versionAPP: @Sendable() -> String = { "" }
    public var buildNumberApp: @Sendable() -> String = { "" }
    
    public init() {}
}

public extension DependenciesInjection {
    
    var fhkConfiguration: FHKConfiguration {
        get { get(FHKConfiguration.self, preview: .preview, testing: .test) }
        set { set(newValue, for: FHKConfiguration.self) }
    }
}

#if DEBUG
extension FHKConfiguration {
    
    static var test: Self {
        Self()
    }
    
    
    static var preview: Self {
     var preview = Self()
        
        preview.parentMail = {
            "parent@email.com"
        }
        
        preview.familyName = {
            "Family Name Test"
        }
        
        preview.approvePin = {
            "0000"
        }
        
        preview.getEnvironment = {
            .production
        }
        
        preview.accessToken = {
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9"
        }
        
        preview.refreshToken = {
            "lYWQ6dXNlcnMiLCJpYXQiOjE3MzE5MjM0MDB9"
        }
        
        preview.deleteTokens = {
            
        }
        
        preview.versionAPP = {
            "1.0.1"
        }
        
        preview.buildNumberApp = {
            "1"
        }
        
     return preview
    }
}
#endif
