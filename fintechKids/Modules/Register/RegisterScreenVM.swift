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
    private var fhkFirebaseAnalitycs: any FHKAnalyticsProtocol {
        inject.fhkFirebaseAnalitycs
    }
    
    private var fhkRegisterRepository: any RegisterRepositoryProtocol {
        inject.fhkRegisterRepository
    }
    
    public var fhkModal: any FHKModalProtocol {
        inject.fhkModal
    }
    
    enum Action: Equatable {
        case registerUser
        case onAppear
    }
    
    @MainActor
    func action(_ action: Action) async {
        switch action {
            
        case .registerUser:
            await registerUser()
             
        case .onAppear:
            await onAppear()
        }
    }
    
    func onAppear() async {}
    
    @MainActor
    func registerUser() async {
        viewState.registerState = .loading
        
        do {
            let response = try await fhkRegisterRepository.register(
                email: viewState.emailFamily,
                password: viewState.password,
                familyName: viewState.familyName
            )
            
            try fhkRegisterRepository.saveFamilyInfoKeychain(familyName: viewState.familyName)
            
            viewState.registerState = .finish(result: .success)
            Logger.info("USER REGISTERED SUCCESS \(response)")
        } catch let error as FHKSupabaseError {
            viewState.registerState = .finish(result: .error)
            informateError(error)
        } catch {
            viewState.registerState = .finish(result: .error)
            informateError(FHKRegisterError.registerUserFailed)
        }
    }
}

private extension RegisterScreenVM {
    
    func informateError(_ error: any FHKError) {
        if error.isShouldTrack {
            fhkFirebaseAnalitycs.track(.error(.init(from: error)))
        }
        
        viewState.msnRegisterFail = error.messageLocalized
        Logger.error(error.logMessage)
    }
}
