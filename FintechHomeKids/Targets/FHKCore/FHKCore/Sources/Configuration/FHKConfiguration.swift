//
//  FHKConfiguration.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 4/9/26.
//

import Foundation

public struct FHKConfiguration: Sendable {
    public var parentMail: @Sendable() -> String? = { nil }
    public var familyName: @Sendable() -> String? = { nil }
    public var approvePin: @Sendable() -> String? = { nil }
    public var environmentType: @Sendable() -> EnvironmentType = { .remote }
    
    public var refreshParentMail: @Sendable() -> Void = { }
    public var refreshFamilyName: @Sendable() -> Void = { }
    public var setEnvironment: @Sendable(EnvironmentType) -> Void = { _ in }
    public var getEnvironment: @Sendable() -> EnvironmentType = { .remote }
    
    
    public init() {}
}
