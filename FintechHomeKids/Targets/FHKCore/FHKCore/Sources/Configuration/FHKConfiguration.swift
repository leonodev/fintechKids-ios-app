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
    public var setEnvironment: @Sendable(EnvironmentType) -> Void = { _ in }
    public var getEnvironment: @Sendable() -> EnvironmentType = { .remote }
    
    
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
            .remote
        }
        
     return preview
    }
}
#endif
