//
//  FHKRemoteConfig.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 28/8/26.
//

public struct FHKRemoteConfig: Sendable {
    public var enabledLanguages: @Sendable() -> [String] = { [] }
    public var menuHomeItems: @Sendable() -> [MenuHomeItem] = { [] }
    public var fetchConfig: @Sendable() async throws -> Void = { }
    public var getCachedTimeExpiration: @Sendable() async -> Int = { 3 /* Minutes */ }
    
    public init() {}
}
