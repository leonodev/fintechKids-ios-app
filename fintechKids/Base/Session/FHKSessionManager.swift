//
//  FHKSessionManager.swift
//  fintechKids
//
//  Created by fleon  on 10/6/26.
//

import Foundation
import Observation
import FHKDomain
import FHKInjections

@Observable
public final class FHKSessionManager: FHKSessionManagerProtocol {
    public var isAuthenticated: Bool = false
    private let authKey = UserDefaultsKeys.isUserAutenicatedKey
    
    private var fhkStorage: any FHKStorageManagerProtocol {
        inject.fhkStorage
    }

    public func initializeSession() async {
        let status = (try? await fhkStorage.readUserDefaults(Bool.self, forKey: authKey)) ?? false
        self.isAuthenticated = status
    }

    public func login() async throws {
        try await fhkStorage.saveUserDefaults(true, forKey: authKey)
        self.isAuthenticated = true
    }

    public func logout() async throws {
        try await fhkStorage.saveUserDefaults(false, forKey: authKey)
        self.isAuthenticated = false
        try fhkStorage.clearAllKeychain()
    }
}
