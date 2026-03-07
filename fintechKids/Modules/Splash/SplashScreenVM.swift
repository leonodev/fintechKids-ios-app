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

            viewState.splashState = isLanguageSelected != nil
            ? .loaded(nav: .goToLogin)
            : .loaded(nav: .goToLanguage)
        } catch {
            viewState.splashState = .loaded(nav: .goToLanguage)
        }
    }
}
