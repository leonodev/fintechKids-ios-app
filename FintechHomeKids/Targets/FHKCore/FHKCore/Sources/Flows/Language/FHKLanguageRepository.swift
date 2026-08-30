//
//  FHKLanguageRepository.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 28/8/26.
//

public struct FHKLanguageRepository: Sendable {
    public var fetchConfig: @Sendable() async -> [String] = { [] }
    public var changeLanguageApp: @Sendable(String) async -> Void = { _ in }
    
    public init() {}
}
