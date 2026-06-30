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
    
    private func getStateUser(hasLanguageSelected: Bool) -> SplashViewState.State {
        if hasLanguageSelected {
            return .loaded(nav: .goToLogin)
        } else {
            return .loaded(nav: .goToLanguage)
        }
    }
}
