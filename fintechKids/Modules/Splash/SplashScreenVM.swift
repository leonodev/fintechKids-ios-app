//
//  SplashScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 20/12/25.
//

import Foundation
import SwiftUI
import Combine
import FHKCore
import FHKConfig
import FHKStorage
import FHKUtils

final class SplashScreenVM: ObservableObject {
    
    private let storage: UserDefaultsProtocol
    var languageApp: String?
    @Published var isConfigLanguageReady: Bool = false
    
    public init(storage: UserDefaultsProtocol = UserDefaultStorage()) {
        self.storage = storage
        
        Task { await readLanguage() }
    }
    
    public func readLanguage() async {
        do {
            languageApp = try await storage.read(String.self, forKey: UserDefaultsKeys.languageKey)
        } catch {
            Logger.error("Error reading: \(error)")
        }
        isConfigLanguageReady = true
    }
}


