//
//  FHKForgotScreenVM.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 21/11/2026.
//

import Observation
import FHKCore
import FHKDomain
import FLibUtils
import FLibInjections

@Observable
final class FHKForgotScreenVM: FHKCore.ViewModel {
    var viewState: FHKForgotViewState = .init()
    
    // Properties injected
    private var fhkForgotPasswordRepository: FHKForgotPasswordRepository {
        inject.fhkForgotPasswordRepository
    }
    
    private var fhkAnalitycs: FHKAnalytics {
        inject.fhkAnalitycs
    }
    
    public init() {}
    
    enum Action: Equatable {
        case forgotPassword
        case resetPassword
        case retry
    }
    
    @MainActor
    func action(_ action: Action) async {
        switch action {
        case .forgotPassword:
            await forgotPassword()
            
        case .resetPassword:
            await resetPassword()
            
        case .retry:
            await retry()
        }
    }
    
    @MainActor
    func forgotPassword() async {
        viewState.forgotState = .loading
        
        do {
            let forgotInfo = try await fhkForgotPasswordRepository.forgot(viewState.email)
            
            viewState.debugRecoveryCode = forgotInfo.debugRecoveryCode
            viewState.forgotState = .loaded(.resetPassword)
            
        } catch let appError {
            // If the Task was cancelled when the view was closed, we exit silently.
            if appError == .cancelled { return }
            
            viewState.forgotState = .error
            informateError(appError)
            
            // If you want to react to a specific case from the backend:
            if case .backend(.recoveryCodeExpired, _) = appError {/* Here */}
        }
    }
    
    @MainActor
    func resetPassword() async {
        viewState.forgotState = .loading
        
        do {
            let entityReset = FHKResetPasswordParams(
                email: viewState.email,
                recoveryCode: viewState.code,
                newPassword: viewState.newPassword
            )
            
            _ = try await fhkForgotPasswordRepository.reset(entityReset)
            viewState.forgotState = .finish
            
        } catch let appError {
            // If the Task was cancelled when the view was closed, we exit silently.
            if appError == .cancelled { return }
            
            viewState.forgotState = .error
            informateError(appError)
            
            // If you want to react to a specific case from the backend:
            if case .backend(.recoveryCodeExpired, _) = appError {/* Here */}
        }
    }
    
    @MainActor
    func retry() async {
        viewState.forgotState = .loaded(.resetPassword)
    }
        
        
    private func informateError(_ error: some FHKError) {
        // We only send to Firebase if the error is configured to be reported.
        if error.isShouldTrack {
            fhkAnalitycs.track(.error(.init(from: error)))
        }
        
        // We display the translated message (with a safe fallback in case the key is empty)
        let key = error.msnLocalizedKey.isEmpty ? "error_server_generic" : error.msnLocalizedKey
        viewState.msnForgotPasswordFail = key.localized
        
        // We print the full details to the console (Debug)
        Logger.error(error.logMessage)
    }
}
