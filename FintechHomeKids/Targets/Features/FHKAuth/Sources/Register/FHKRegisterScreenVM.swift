//
//  FHKRegisterScreenVM.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 5/9/26.
//

import Observation
import FHKCore
import FHKDomain
import FLibUtils
import FLibInjections

@Observable
final class FHKRegisterScreenVM: FHKCore.ViewModel {
    var viewState: FHKRegisterViewState = .init()
    
    // Properties Injected
    private var fhkAnalitycs: FHKAnalytics {
        inject.fhkAnalitycs
    }
    
    private var fhkRegisterRepository: FHKRegisterRepository {
        inject.fhkRegisterRepository
    }
    
    public var fhkModal: FHKModal {
        inject.fhkModal
    }
    
    public init() {}
    
    enum Action: Equatable {
        case registerUser
    }
    
    @MainActor
    func action(_ action: Action) async {
        switch action {
        case .registerUser:
            await registerUser()
        }
    }
    
    @MainActor
    func registerUser() async {
        viewState.registerState = .loading
        
        do {
            let registerUserEntity = FHKRegisterEntity(email: viewState.emailFamily,
                                                       password: viewState.password,
                                                       familyName: viewState.familyName,
                                                       approvePIN: viewState.pinApproveTask)
            let response = try await fhkRegisterRepository.register(registerUserEntity)
            
            try fhkRegisterRepository.saveFamilyInfoKeychain(viewState.familyName)
            
            viewState.registerState = .finish(result: .success)
            Logger.info("USER REGISTERED SUCCESS \(response)")
//        } catch let error as FHKSupabaseError {
//            viewState.registerState = .finish(result: .error)
//            informateError(error)
        } catch {
            viewState.registerState = .finish(result: .error)
            informateError(FHKRegisterError.registerUserFailed)
        }
    }
    
    func informateError(_ error: some FHKError) {
        // We only send to Firebase if the error is configured to be reported.
        if error.isShouldTrack {
            fhkAnalitycs.track(.error(.init(from: error)))
        }
        
        // We show the user the localized message (UX)
        viewState.msnRegisterFail = error.msnLocalizedKey.localized
        
        // We print the full details to the console (Debug)
        Logger.error(error.logMessage)
    }
}
