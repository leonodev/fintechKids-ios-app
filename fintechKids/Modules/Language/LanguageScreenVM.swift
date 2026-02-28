//
//  LanguageScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 10/12/25.
//

import SwiftUI
import Observation
import FHKCore
import FHKDesignSystem
import FHKFirebase
import FHKInjections
import FHKDomain

@Observable
public final class LanguageScreenVM: FHKCore.ViewModel {
    var model: LanguageModel = .init()
    var languages: [String] = []
    var selectedFlag: Image = .noneFlag
    
    // Injections Dependency
    private var analitycsManager: any FHKAnalyticsProtocol {
        inject.firebaseAnalitycsManager
    }
    
    private var languageManager: any FHKLanguageManagerProtocol {
        inject.languageManager
    }
    
    private var remoteConfigManager: any FHKRemoteConfigManagerProtocol {
        inject.firebaseRemoteConfigManager
    }
    
    public let allFlags: [Image] = [
        .spainCircleFlag,
        .italyCircleFlag,
        .englandCircleFlag,
        .franceCircleFlag
    ]
    
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
    
    private func loadRemoteConfig() async {
        remoteConfigManager.fetchConfig { [weak self] error in
            guard let self = self else { return }
            
            if error != nil {
                self.model.languageState = .error(FHKSystemError.remoteConfigFailed)
            } else {
                self.languages = self.remoteConfigManager.enabledLanguages
                self.model.languageState = .loaded
            }
        }
    }
    
    private func setImageFlag(code: String?) {
        let languageCode = code ?? LanguageType.es.code()
        selectedFlag =  languageCode.languageTypeToImageFlag
    }
    
    private func changeLanguageApp(_ language: String) async {
        languageManager.changeLanguage(to: language)
    }
}

// Analytics Methods
extension LanguageScreenVM {
    
    private func sendAnalitycOpenScreen() async {
        analitycsManager.track(.screenView(Screens.Language.screen))
    }
    
    private func sendAnalitycSelectLanguage(btn: AnalyticsEvent.Button) async {
        analitycsManager.track(.tapButton(btn))
    }
}
