//
//  FHKSplashScreenVM.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 25/8/26.
//

import Observation
import FHKCore
import FHKDomain
import FHKDesignSystem

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
        case checkVersion
        case tryCheckVersion
    }
    
    @MainActor
    public func action(_ action: Action) async {
        switch action {
          
        case .readLanguageCurrent:
            await readLanguageCurrent()
            
        case .checkVersion:
            await checkVersion()
            
        case .tryCheckVersion:
            await tryCheckVersion()
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
    
    @MainActor
    private func checkVersion() async {
        do {
            let checkVersion = try await fhkSplashRepository.checkVersion()
            
            if let versionInfo = checkVersion {
                await validateStateVersionApp(info: versionInfo)
            } else {
                viewState.splashState = .versionApp(state: .error)
            }
        } catch {
            viewState.splashState = .versionApp(state: .error)
        }
    }
    
    @MainActor
    private func tryCheckVersion() async {
        viewState.splashState = .loading
        await checkVersion()
    }
    
    private func validateStateVersionApp(info: FHKAppVersionEntity) async {
        let currentStateApp = VersionAppState.evaluate(
            currentVersion: info.currentVersion,
            latestVersion: info.latestVersion,
            forceUpdate: info.forceUpdate
        )
        
        if currentStateApp == .upToDate {
            await readLanguageCurrent()
        } else {
            viewState.splashState = .versionApp(state: currentStateApp)
            viewState.latestVersion = info.latestVersion
            viewState.releaseNotes = info.releaseNotes ?? "-"
            viewState.storeUrl = info.storeUrl ?? "-"
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
