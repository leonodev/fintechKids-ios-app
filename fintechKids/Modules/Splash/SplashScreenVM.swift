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
    private var splashRepository: any FHKSplashRepositoryProtocol {
        inject.splashRepository
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
    public func readLanguageCurrent() async {
        do {
            let isLanguageSelected = try await splashRepository.readLanguageCurrent()

            viewState.splashState = isLanguageSelected != nil
                ? .finish(.goToLogin)
                : .finish(.goToLanguage)
        } catch {
            viewState.splashState = .finish(.goToLanguage)
        }
    }
}
