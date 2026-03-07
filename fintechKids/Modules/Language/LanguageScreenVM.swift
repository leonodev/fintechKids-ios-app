//
//  LanguageScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 10/12/25.
//

import Observation
import FHKCore
import FHKFirebase
import FHKInjections
import FHKDomain
import FHKUtils

@Observable
public final class LanguageScreenVM: FHKCore.ViewModel {
    var viewState: LanguageViewState = .init()
    var languages: [String] = []
    
    // Injections Dependency
    private var fhkFirebaseAnalitycs: any FHKAnalyticsProtocol {
        inject.fhkFirebaseAnalitycs
    }
    
    private var fhkLanguageRepository: any FHKLanguageRepositoryProtocol {
        inject.fhkLanguageRepository
    }
    
    public enum Action: Equatable {
        case loadRemoteConfig
        case changeImageFlag(String)
        case changeLanguageApp(String)
        case sendAnalitycOpenScreen
        case sendAnalitycSelectLanguage(btn: AnalyticsEvent.Button)
    }
    
    public init() {}
    
    @MainActor
    public func action(_ action: Action) async {
        switch action {
            
        case .loadRemoteConfig:
            await loadRemoteConfig()
            
        case .changeImageFlag(let language):
            setImageFlag(code: language)
            
        case .changeLanguageApp(let language):
            await changeLanguageApp(language)
            
        case .sendAnalitycOpenScreen:
            await sendAnalitycOpenScreen()
            
        case .sendAnalitycSelectLanguage(let btn):
            await sendAnalitycSelectLanguage(btn: btn)
        }
    }
    
    public func getBtnLanguage(code: String) -> AnalyticsEvent.Button {
        Screens.Language.getBtnLanguag(lng: code)
    }
}

// Private Methods
private extension LanguageScreenVM {
    
    private func loadRemoteConfig() async {
        let remoteLanguage = await fhkLanguageRepository.fetchConfig()
        
        if remoteLanguage.isEmpty {
            informateError(FHKSystemError.remoteConfigFailed)
            // display screen loaded for selection language
            viewState.languageState = .loaded
        } else {
            languages = remoteLanguage
            viewState.languageState = .loaded
        }
    }
    
    private func setImageFlag(code: String?) {
        let languageCode = code ?? LanguageType.es.code()
        viewState.selectedFlag =  languageCode.languageTypeToImageFlag
    }
    
    private func changeLanguageApp(_ language: String) async {
        await fhkLanguageRepository.changeLanguageApp(language)
    }
    
    private func informateError(_ error: any FHKError) {
        if error.isShouldTrack {
            fhkFirebaseAnalitycs.track(.error(.init(from: error)))
        }
        
        Logger.error(error.logMessage)
    }
    
    private func sendAnalitycOpenScreen() async {
        fhkFirebaseAnalitycs.track(.screenView(Screens.Language.screen))
    }
    
    private func sendAnalitycSelectLanguage(btn: AnalyticsEvent.Button) async {
        fhkFirebaseAnalitycs.track(.tapButton(btn))
    }
}
