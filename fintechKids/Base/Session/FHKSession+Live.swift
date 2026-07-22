//
//  FHKSessionManager.swift
//  fintechKids
//
//  Created by fleon  on 10/6/26.
//

import Foundation
import FHKDomain
import FHKInjections
import FHKStorage

public extension FHKSession {
    
    static var live: Self {
        let authKey = UserDefaultsKeys.isUserAutenicatedKey
        let state = SessionState()
        var session = Self()
        
        session.isAuthenticated = {
            state.hasAuthentication
        }
        
        session.setIsAuthenticated = { newValue in
            state.hasAuthentication = newValue
        }
        
        session.initializeSession = {
            let status = (try? await inject.fhkStorage.readUserDefaults(Bool.self, forKey: authKey)) ?? false
            await MainActor.run {
                state.hasAuthentication = status
            }
        }
        
        session.login = {
            try await inject.fhkStorage.saveUserDefaults(true, forKey: authKey)
            await MainActor.run {
                state.hasAuthentication = true
            }
        }
        
        session.logout = {
            try await inject.fhkStorage.saveUserDefaults(false, forKey: authKey)
            try inject.fhkStorage.clearAllKeychain()
            await MainActor.run {
                state.hasAuthentication = false
            }
        }
        
        return session
    }
}

@MainActor
private final class SessionState {
    var hasAuthentication: Bool = false
}
