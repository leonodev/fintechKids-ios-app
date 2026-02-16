//
//  LanguageScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 10/12/25.
//

import SwiftUI
import Observation
import FHKCore
import FHKConfig
import FHKUtils
import FHKAuth
import FHKStorage
import FHKDesignSystem
import FHKObservability
import FHKInjections

@Observable
public final class LanguageScreenVM: FHKCore.ViewModel {
    var model: LanguageModel = .init()
    var languages: [String] = []
    var selectedFlag: Image = .noneFlag
    
    // Injections Dependency
    private let languageManager = inject.languageManager
    private let storagemanager = inject.storagemanager
    private let remoteConfigManager = inject.remoteConfigManager
    private let analitycsManager = inject.analitycsManager
    
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
        case saveLanguage(String)
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
            
        case .saveLanguage(let language):
            await saveLanguage(language)
            
        case .sendAnalitycOpenScreen:
            await sendAnalitycOpenScreen()
            
        case .sendAnalitycSelectLanguage(let btn):
            await sendAnalitycSelectLanguage(btn: btn)
        }
    }
    
    private func loadRemoteConfig() async {
        remoteConfigManager.fetchConfig { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.model.languageState = .error(
                    Log(error: error,
                        attributes: LogAttributes(action: self.nameAction,
                                                  feature: .language)
                    )
                )
            } else {
                self.languages = self.remoteConfigManager.enabledLanguages
                self.model.languageState = .loaded
            }
        }
    }
    
    private func setImageFlag(code: String?) {
        let languageCode = code ?? Configuration.LanguageType.es.code()
        let languageType = Configuration.languageTypeFromCode(languageCode)
        selectedFlag =  languageType.languageTypeToImageFlag
    }
    
    private func changeLanguageApp(_ language: String) async {
        languageManager.selectedLanguage = language
    }
    
    private func saveLanguage(_ language: String) async {
        do {
            try await storagemanager.saveUserDefaults(language, forKey: UserDefaultsKeys.languageKey)
        }
        catch {
            self.model.languageState = .error(
                Log(error: error,
                    attributes: LogAttributes(action: self.nameAction,
                                              feature: .language)
                )
            )
        }
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
