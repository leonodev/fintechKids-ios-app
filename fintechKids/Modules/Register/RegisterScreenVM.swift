//
//  RegisterScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 23/1/26.
//

import SwiftUI
import Observation
import FHKCore
import FHKAuth
import FHKUtils
import FHKInjections
import FHKDomain

@Observable
final class RegisterScreenVM: FHKCore.ViewModel {
    var model: RegisterModel = .init()
    
    // Properties injected
    private var securityManager: any FHKSecurityProtocol {
        inject.securityManager
    }
    
    private var storageManager: any FHKStorageManagerProtocol {
        inject.storageManager
    }
    
    private var supabase: any FHKAuthProtocol {
        inject.supabaseManager
    }
    
    enum Action: Equatable {
        case registerUser
        case onAppear
    }
    
    @MainActor
    func action(_ action: Action) async {
        switch action {
            
        case .registerUser:
            
            // Make register
            await registerUser(passwordHashed: model.password)

            // save user in Keychain
            await saveUserIntoKeychain()
             
        case .onAppear:
            await onAppear()
        }
    }
    
    func onAppear() async {}
    
    @MainActor
    func registerUser(passwordHashed: String?) async {
        do {
            let _ = try await supabase.register(email: model.emailFamily,
                                                password: model.password)
            model.registerState = .finish(nil)
        } catch let error as FHKDomainError {
            model.registerState = .error(error)
        } catch {
            model.registerState = .error(FHKAppError.registerUserFailed)
        }
    }
}

private extension RegisterScreenVM {
    
    func saveUserIntoKeychain() async {
        do {
            try storageManager.saveKeychain(model.emailFamily, for: KeychainKeys.userKey)
            Logger.info("USER SAVED INTO KEYCHAIN SUCCESS")
        } catch {
            model.registerState = .error(FHKSecurityError.saveUserMailKeychainFailed)
        }
    }
}
