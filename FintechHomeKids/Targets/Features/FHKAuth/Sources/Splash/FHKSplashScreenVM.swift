//
//  FHKSplashScreenVM.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 25/8/26.
//

import Observation
import FHKCore
import FHKDomain

@Observable
public final class FHKSplashScreenVM: FHKCore.ViewModel {
    var viewState: FHKSplashViewState = .init()
    
    public init() {}
    
    // Properties Injected
    private var fhkSplashRepository: FHKSplashRepository {
        inject.fhkSplashRepository
    }
    
    private var fhkLoginRepository: FHKLoginRepository {
        inject.fhkLoginRepository
    }
    
    var hasSavedAuthToken: Bool {
        fhkLoginRepository.hasSavedToken()
    }
    
    public enum Action: Equatable {
        case readLanguageCurrent
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
    
    private func getStateUser(hasLanguageSelected: Bool) -> FHKSplashViewState.State {
        if hasLanguageSelected && !hasSavedAuthToken {
            return .loaded(nav: .goToLogin)
        } else if hasLanguageSelected && hasSavedAuthToken {
            return .loaded(nav: .gotoHome)
        } else {
            return .loaded(nav: .goToLanguage)
        }
    }
}
