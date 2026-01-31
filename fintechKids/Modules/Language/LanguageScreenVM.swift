//
//  LanguageScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 10/12/25.
//

import SwiftUI
import Combine
import FHKConfig
import FHKUtils
import FHKAuth
import FHKStorage
import FHKDesignSystem

public final class LanguageScreenVM<T: RemoteConfigManagerProtocol>: ObservableObject {
    private var configManager: T
    
    @Published var languages: [String] = []
    @Published var initialLanguageCode: String = Configuration.getLanguage().code()
    @Published var selectedFlag: Image = .spainCircleFlag
    
    public let allFlags: [Image] = [
        .spainCircleFlag,
        .italyCircleFlag,
        .englandCircleFlag,
        .franceCircleFlag
    ]
    
    private let storage: UserDefaultsProtocol
    private var cancellables = Set<AnyCancellable>()
    
    public init(configManager: T, storage: UserDefaultsProtocol = UserDefaultStorage()) {
        self.configManager = configManager
        self.storage = storage
        Task {
            await readLanguage()
        }
        
        configManager.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let newLanguages = configManager.enabledLanguages
                self?.languages = newLanguages
                Logger.info("\(newLanguages)")
                
                if self?.initialLanguageCode == Configuration.LanguageType.es.code() && !newLanguages.isEmpty {
                    self?.initialLanguageCode = newLanguages.first ?? Configuration.LanguageType.es.code()
                }
            }
            .store(in: &cancellables)
    }

    public func loadConfig() {
        configManager.fetchConfig { [weak self] error in
            // Forzamos la actualización al terminar el fetch
            DispatchQueue.main.async {
                guard let self = self else { return }
                if let error = error {
                    Logger.error("Error: \(error.localizedDescription)")
                } else {
                    // Actualizamos manualmente para asegurar que tenemos la última data
                    self.languages = self.configManager.enabledLanguages
                    Logger.info("Remote Config Cargado: \(self.languages)")
                }
            }
        }
    }
    
    public func saveLanguage(_ language: String) async {
        await LanguageManager.shared.saveLanguage(language)
        await MainActor.run {
            setImageFlag(code: language)
        }
    }
    
    public func readLanguage() async {
        await LanguageManager.shared.readLanguage()
        let languageCode = LanguageManager.shared.selectedLanguage
        await MainActor.run {
            setImageFlag(code: languageCode)
        }
    }
    
    private func setImageFlag(code: String?) {
        let languageCode = code ?? Configuration.LanguageType.es.code()
        let languageType = Configuration.languageTypeFromCode(languageCode)
        selectedFlag =  languageType.languageTypeToImageFlag
    }
}
