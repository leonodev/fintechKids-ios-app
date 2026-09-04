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
        
        config.environmentType = {
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
        
        config.getEnvironment = {
            state.getEnvironment()
        }
        
        return config
    }
}

private final class LiveState: @unchecked Sendable {
    private let lock = NSLock()
    
    private var parentMail: String?
    private var familyName: String?
    private var approvePin: String?
    private var environmentType: EnvironmentType = .remote
    
    private var storage: FHKStorageManager {
        inject.fhkStorage
    }
    
    init() {
        // Initial load from the Keychain at startup
        self.parentMail = try? storage.readKeychain(String.self,
                                                    for: KeychainKeys.userKey, prompt: nil)
        self.familyName = try? storage.readKeychain(String.self,
                                                    for: KeychainKeys.familyNameKey, prompt: nil)
        self.approvePin = try? storage.readKeychain(String.self,
                                                    for: KeychainKeys.approvePinKey, prompt: nil)
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
    
    func getEnvironment() -> EnvironmentType {
        lock.withLock { environmentType }
    }
    
    // MARK: - Mutaciones Protegidas
    func setEnvironment(_ env: EnvironmentType) {
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
}
