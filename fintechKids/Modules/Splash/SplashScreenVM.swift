//
//  SplashScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 20/12/25.
//

import Foundation
import SwiftUI
import Observation
import FHKCore
import FHKConfig
import FHKStorage
import FHKUtils
import FHKInjections

@Observable
final class SplashScreenVM: FHKCore.ViewModel {
    var model: SplashModel = .init()
    
    // Properties Injected
    private var storageManager: any FHKStorageManagerProtocol {
        inject.storageManager
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
            let isLanguageSelected =
            try await storageManager.readUserDefaults(String.self,
                                                      forKey: UserDefaultsKeys.languageKey)
            
            model.splashState = isLanguageSelected != nil
                ? .finish(.goToLogin)
                : .finish(.goToLanguage)
        } catch {
            model.splashState = .finish(.goToLanguage)
            Logger.error(error.localizedDescription)
        }
    }
}
