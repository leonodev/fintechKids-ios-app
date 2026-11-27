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
    public var refreshApprovePin: @Sendable() -> Void = { }
    public var refreshToken: @Sendable() -> String? = { nil }
    public var setEnvironment: @Sendable(FHKEnvironmentType) -> Void = { _ in }
    public var getEnvironment: @Sendable() -> FHKEnvironmentType = { .current }

    public var versionAPP: @Sendable() -> String = { "" }
    public var buildNumberApp: @Sendable() -> String = { "" }
    
    public var accessToken: @Sendable() -> String? = { nil }
    public var saveTokens: @Sendable (_ accessToken: String, _ refreshToken: String) throws -> Void = { _, _ in }
    public var deleteTokens: @Sendable () throws -> Void = { }
    public var hasSavedToken: @Sendable () -> Bool = { false }
    
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
        
        preview.versionAPP = {
            "1.0.1"
        }
        
        preview.buildNumberApp = {
            "1"
        }
        
        preview.accessToken = {
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9"
        }
        
        preview.refreshToken = {
            "lYWQ6dXNlcnMiLCJpYXQiOjE3MzE5MjM0MDB9"
        }
        
        preview.refreshParentMail = {}
        preview.refreshApprovePin = {}

        preview.deleteTokens = {}
        
        preview.saveTokens = {_,_ in }
        
        preview.hasSavedToken = { true }
        
     return preview
    }
}
#endif
