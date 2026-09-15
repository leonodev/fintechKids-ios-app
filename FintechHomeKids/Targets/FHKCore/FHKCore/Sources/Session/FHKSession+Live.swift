//
//  FHKSession+Live.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 27/8/26.
//

import Foundation
import FLibInjections
import FLibStorage

public extension FHKSession {
    @MainActor
    fileprivate static let state = SessionState()
    
    static var live: Self {
        let authKey = UserDefaultsKeys.isUserAutenicatedKey
        
        
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
@Observable
private final class SessionState {
    var hasAuthentication: Bool = false
}
