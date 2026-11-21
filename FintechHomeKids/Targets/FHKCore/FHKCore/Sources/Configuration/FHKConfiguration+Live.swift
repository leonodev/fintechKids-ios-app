//
//  FHKConfiguration+Live.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 4/9/26.
//

import Foundation
import FLibInjections
import FLibStorage

public extension FHKConfiguration {
    
    static var live: Self {
        let state = LiveState()
        
        var config = Self()
        
        config.parentMail = {
            state.readParentMail()
        }
        config.familyName = {
            state.readFamilyName()
        }
        
        config.approvePin = {
            state.readApprovePin()
        }
        
        config.getEnvironment = {
            state.getEnvironment()
        }
        
        config.refreshParentMail = {
            state.refreshParentMail()
        }
        
        config.refreshFamilyName = {
            state.refreshFamilyName()
        }
        
        config.setEnvironment = {
            env in state.setEnvironment(env)
        }
        
        config.accessToken = {
            state.readAccessToken()
        }
        
        config.refreshToken = {
            state.readRefreshToken()
        }
        
        config.deleteTokens = {
            try state.clearTokens()
        }
        
        config.versionAPP = {
            Bundle.main.appVersion
        }
        
        config.buildNumberApp = {
            Bundle.main.buildNumber
        }
        
        return config
    }
}

private final class LiveState: @unchecked Sendable {
    private let lock = NSLock()
    
    private var parentMail: String?
    private var familyName: String?
    private var approvePin: String?
    private var accessToken: String?
    private var refreshToken: String?
    private var environmentType: FHKEnvironmentType = .current
    
    private var storage: FHKStorageManager {
        inject.fhkStorage
    }
    
    init() {
        // Initial load from the Keychain at startup
        self.parentMail = try? storage.readKeychain(String.self,
                                                    for: KeychainKeys.userKey,
                                                    prompt: nil)
        self.familyName = try? storage.readKeychain(String.self,
                                                    for: KeychainKeys.familyNameKey,
                                                    prompt: nil)
        self.approvePin = try? storage.readKeychain(String.self,
                                                    for: KeychainKeys.approvePinKey,
                                                    prompt: nil)
        
        self.accessToken = try? storage.readKeychain(String.self,
                                                     for: KeychainKeys.accessTokenKey,
                                                     prompt: nil)
        
        self.refreshToken = try? storage.readKeychain(String.self,
                                                      for: KeychainKeys.refreshTokenKey,
                                                      prompt: nil)
    }
    
    // MARK: - Getters Protegidos
    func readParentMail() -> String? {
        lock.withLock { parentMail }
    }
    
    func readFamilyName() -> String? {
        lock.withLock { familyName }
    }
    
    func readApprovePin() -> String? {
        lock.withLock { approvePin }
    }
    
    func getEnvironment() -> FHKEnvironmentType {
        lock.withLock { environmentType }
    }
    
    // MARK: - Mutaciones Protegidas
    func setEnvironment(_ env: FHKEnvironmentType) {
        lock.withLock { environmentType = env }
    }
    
    func refreshParentMail() {
        let newValue = try? storage.readKeychain(String.self, for: KeychainKeys.userKey, prompt: nil)
        lock.withLock { parentMail = newValue }
    }
    
    func refreshFamilyName() {
        let newValue = try? storage.readKeychain(String.self, for: KeychainKeys.familyNameKey, prompt: nil)
        lock.withLock { familyName = newValue }
    }
    
    func readAccessToken() -> String? {
        lock.withLock { accessToken }
    }
    
    func readRefreshToken() -> String? {
        lock.withLock { refreshToken }
    }
    
    // MARK: - Saved and clear (Keychain + Memory in one step)
    func saveTokens(accessToken: String, refreshToken: String) throws {
        try storage.saveKeychain(accessToken, for: KeychainKeys.accessTokenKey,
                                 requireBiometry: false)
        
        try storage.saveKeychain(refreshToken, for: KeychainKeys.refreshTokenKey,
                                 requireBiometry: false)
        
        lock.withLock {
            self.accessToken = accessToken
            self.refreshToken = refreshToken
        }
    }
    
    func clearTokens() throws {
        try storage.deleteKeychain(KeychainKeys.accessTokenKey)
        try storage.deleteKeychain(KeychainKeys.refreshTokenKey)
        
        lock.withLock {
            self.accessToken = nil
            self.refreshToken = nil
        }
    }
}
