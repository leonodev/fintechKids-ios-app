//
//  CachedData.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import Foundation
import FLibInjections

public struct CachedData<T: Sendable>: Sendable {
    public let content: T
    public let timestamp: Date
    
    private var fhkFirebaseRemoteConfig: FHKRemoteConfig {
        inject.fhkRemoteConfig
    }
    
    public init(content: T) {
        self.content = content
        self.timestamp = Date()
    }
    
    public func isExpired() async -> Bool {
        let timeExpirationConfig = await fhkFirebaseRemoteConfig.getCachedTimeExpiration()
        let expirationTime = Double(timeExpirationConfig * 60)
        return Date().timeIntervalSince(timestamp) > expirationTime
    }
}
