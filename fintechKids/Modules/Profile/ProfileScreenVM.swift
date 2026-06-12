//
//  ProfileScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 16/2/26.
//

import Observation
import FHKCore
import FHKInjections
import FHKDomain
import FHKFirebase
import FHKUtils

@Observable
final class ProfileScreenVM: FHKCore.ViewModel {
    var viewState: ProfileViewState = .init()
    
    // Properties Injected
    private var fhkProfileRepository: any FHKProfileRepositoryProtocol {
        inject.fhkProfileRepository
    }
    
    private var fhkFirebaseAnalitycs: any FHKAnalyticsProtocol {
        inject.fhkFirebaseAnalitycs
    }
    
    public var fhkModal: any FHKModalProtocol {
        inject.fhkModal
    }
    
    public var fhkSessionManager: any FHKSessionManagerProtocol {
        inject.fhkSessionManager
    }
    
    public enum Action: Equatable {
        case logout
        case changeLanguageApp(String)
        case openConfirmLogout
    }
    
    @MainActor
    public func action(_ action: Action) async {
        switch action {
            
        case .logout:
            await logoutUser()
            
        case .changeLanguageApp(let lang):
            changeLanguage(newLang: lang)
            
        case .openConfirmLogout:
            openConfirmLogout()
        }
    }
    
    public func getCurrentLanguage() async -> String {
        await fhkProfileRepository.getLanguageCurrent()
    }
    
    public func changeLanguage(newLang: String) {
        fhkProfileRepository.setNewLanguage(lang: newLang)
    }
    
    public func getEmailParent() async -> String {
        do {
            let email = try fhkProfileRepository.getEmailParent()
            return email ?? ""
        } catch {
            informateError(FHKAppError.userDefaultsFailed)
            return ""
        }
    }
    
    func getFamilyName() async -> String {
        await fhkProfileRepository.getFamilyName() ?? ""
    }
}

private extension ProfileScreenVM {
    func logoutUser() async {
        viewState.profileState = .loading
        
        do {
            try await fhkProfileRepository.logout()
            try fhkProfileRepository.deleteKeychain(key: KeychainKey.authToken.rawValue)
            viewState.profileState = .finish(result: .success)
        } catch {
            viewState.profileState = .finish(result: .error)
            informateError(FHKProfileError.logoutUserFailed)
        }
    }
    
    func informateError(_ error: any FHKError) {
        // We only send to Firebase if the error is configured to be reported.
        if error.isShouldTrack {
            fhkFirebaseAnalitycs.track(.error(.init(from: error)))
        }
        
        // We show the user the localized message (UX)
        viewState.msnLogoutResult = error.messageLocalized
        
        // We print the full details to the console (Debug)
        Logger.error(error.logMessage)
    }
    
    func openConfirmLogout() {
        viewState.profileState = .confirmation
    }
}
