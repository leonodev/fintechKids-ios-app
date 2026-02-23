//
//  RegisterScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 23/1/26.
//

import SwiftUI
import Observation
import Supabase
import FHKCore
import FHKAuth
import FHKStorage
import FHKUtils
import FHKInjections

@Observable
final class RegisterScreenVM: FHKCore.ViewModel {
    private let loginActor: Login
    var model: RegisterModel = .init()
    
    // Properties injected
    private var securityManager: any FHKSecurityProtocol {
        inject.securityManager
    }
    
    private var storageManager: any FHKStorageManagerProtocol {
        inject.storageManager
    }
    
    init(loginActor: Login = Login(factory: DefaultAuthServiceFactory())) {
        self.loginActor = loginActor
    }
    
    enum Action: Equatable {
        case registerUser
        case onAppear
    }
    
    @MainActor
    func action(_ action: Action) async {
        switch action {
            
        case .registerUser:
            // Generate securitySeed
            let securitySeed = securityManager.generateSecuritySeed()
            
            // Generate hashed password
            let hashedPassword = await generateHashedPassword(securitySeed: securitySeed)
            
            // Make register
            await registerUser(passwordHashed: hashedPassword)
            
            // save securitySeed in Keychain
            await saveSecuritySeedIntoKeychain(securitySeed: securitySeed)
            
            // save user in Keychain
            await saveUserIntoKeychain()
             
        case .onAppear:
            await onAppear()
        }
    }
    
    func onAppear() async {}
    
    @MainActor
    func registerUser(passwordHashed: String?) async {
        guard let pwdHashed = passwordHashed else {
            model.registerState = .error(FHKSecurityError.generatePasswordHashedFailed)
            return
        }
        
        do {
            try await loginActor.registerUser(platform: .supabase,
                                              email: model.emailFamily,
                                              password: pwdHashed)
            
            model.registerState = .finish(nil)
        } catch let error as FHKDomainError {
            model.registerState = .error(error)
        } catch {
            model.registerState = .error(FHKAppError.registerUserFailed)
        }
    }
}

private extension RegisterScreenVM {
    
    func generateHashedPassword(securitySeed: Data?) async -> String? {
        model.registerState = .loading
        
        // Generate the Hash using the seed
        guard let seed = securitySeed,
                let hashedPassword = securityManager.hashPassword(model.password,
                                                                  securitySeed: seed
        ) else {
            model.registerState = .error(FHKSecurityError.generatePasswordHashedFailed)
            return nil
        }
        
        Logger.info("GENERATE HASED PASSWORD SUCCESS")
        return hashedPassword
    }
    
    func saveSecuritySeedIntoKeychain(securitySeed: Data?) async {
        do {
            // We save the seed in the keychain so that it is available even when reinstalling.
            try storageManager.saveKeychain(securitySeed, for: "securitySeed_\(model.emailFamily)")
            Logger.info("SECURITY-SEED SAVED INTO KEYCHAIN SUCCESS")
        } catch {
            model.registerState = .error(FHKSecurityError.saveSeedFailed)
        }
    }
    
    func saveUserIntoKeychain() async {
        do {
            try storageManager.saveKeychain(model.emailFamily, for: KeychainKeys.userKey)
            Logger.info("USER SAVED INTO KEYCHAIN SUCCESS")
        } catch {
            model.registerState = .error(FHKSecurityError.saveUserMailKeychainFailed)
        }
    }
}
