//
//  RegisterScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 23/1/26.
//

import Observation
import FHKCore
import FHKUtils
import FHKInjections
import FHKDomain
import FHKFirebase

@Observable
final class RegisterScreenVM: FHKCore.ViewModel {
    var viewState: RegisterViewState = .init()
    
    // Properties Injected
    private var analitycsManager: any FHKAnalyticsProtocol {
        inject.firebaseAnalitycsManager
    }
    
    private var repository: any RegisterRepositoryProtocol {
        inject.registerRepository
    }
    
    public var modalManager: any FHKModalProtocol {
        inject.modalManager
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
            await registerUser()

            // save user in Keychain
            await saveUserIntoKeychain()
             
        case .onAppear:
            await onAppear()
        }
    }
    
    func onAppear() async {}
    
    @MainActor
    func registerUser() async {
        do {
            let response = try await repository.register(email: viewState.emailFamily, password: viewState.password)
            viewState.registerState = .finish(nil)
            Logger.info("USER REGISTERED SUCCESS \(response)")
        } catch let error as FHKDomainError {
            viewState.registerState = .error(error)
            informateError(error)
        } catch {
            viewState.registerState = .error(FHKAppError.registerUserFailed)
            informateError(FHKAppError.registerUserFailed)
        }
    }
}

private extension RegisterScreenVM {
    
    func saveUserIntoKeychain() async {
        do {
            try await repository.saveUserIntoKeychain(email: viewState.emailFamily)
            Logger.info("USER SAVED INTO KEYCHAIN SUCCESS")
        } catch {
            viewState.registerState = .error(FHKSecurityError.saveUserMailKeychainFailed)
            informateError(FHKSecurityError.saveUserMailKeychainFailed)
        }
    }
    
    func informateError(_ error: any FHKError) {
        if error.isShouldTrack {
            analitycsManager.track(.error(.init(from: error)))
        }
        
        Logger.error(error.logMessage)
    }
}
