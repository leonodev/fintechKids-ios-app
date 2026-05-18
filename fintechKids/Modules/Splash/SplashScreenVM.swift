//
//  SplashScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 20/12/25.
//

import Observation
import FHKCore
import FHKInjections
import FHKDomain

@Observable
final class SplashScreenVM: FHKCore.ViewModel {
    var viewState: SplashViewState = .init()
    
    // Properties Injected
    private var fhkSplashRepository: any FHKSplashRepositoryProtocol {
        inject.fhkSplashRepository
    }
    
    private var fhkLoginRepository: any FHKLoginRepositoryProtocol {
        inject.fhkLoginRepository
    }
    
    public enum Action: Equatable {
        case readLanguageCurrent
    }
    
    var hasSavedAuthToken: Bool {
        fhkLoginRepository.hasSavedToken
    }
    
    @MainActor
    public func action(_ action: Action) async {
        switch action {
            
        case .readLanguageCurrent:
            await readLanguageCurrent()
        }
    }
    
    @MainActor
    private func readLanguageCurrent() async {
        do {
            let isLanguageSelected = try await fhkSplashRepository.readLanguageCurrent()
            viewState.splashState = getStateUser(hasLanguageSelected: isLanguageSelected != nil)
        } catch {
            viewState.splashState = .loaded(nav: .goToLanguage)
        }
    }
    
    private func getStateUser(hasLanguageSelected: Bool) -> SplashViewState.State {
        if hasLanguageSelected && !hasSavedAuthToken {
            return .loaded(nav: .goToLogin)
        } else if hasLanguageSelected && hasSavedAuthToken {
            return .loaded(nav: .gotoHome)
        } else {
            return .loaded(nav: .goToLanguage)
        }
    }
}
