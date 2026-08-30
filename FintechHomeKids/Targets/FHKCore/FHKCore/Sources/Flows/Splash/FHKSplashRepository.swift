//
//  FHKSplashRepository.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 25/8/26.
//

import Foundation

public struct FHKSplashRepository: Sendable {
    public var readLanguageCurrent: @Sendable () async throws -> String? = { nil }
    
    public init() {}
}



