//
//  LanguageManager.swift
//  fintechKids
//
//  Created by Fredy Leon on 29/12/25.
//

import SwiftUI
import Combine
import FHKStorage
import FHKUtils

public protocol LanguageManagerProtocol: ObservableObject {
    var selectedLanguage: String { get }
    func readLanguage() async
    func saveLanguage(_ language: String) async
}

@MainActor
public final class LanguageManager: LanguageManagerProtocol {
    public static let shared = LanguageManager()
    private let storage: UserDefaultsProtocol = UserDefaultStorage()
    @Published public var selectedLanguage: String = "es"
    
    private init() {}
    
    public func readLanguage() async {
        let languageCode = try? await storage.read(String.self, forKey: UserDefaultsKeys.languageKey)
        let newCode = languageCode ?? "es"
        updateAndNotify(newCode)
    }
    
    public func saveLanguage(_ language: String) async {
        try? await storage.save(language, forKey: UserDefaultsKeys.languageKey)
        updateAndNotify(language)
    }
    
    private func updateAndNotify(_ code: String) {
        self.selectedLanguage = code.lowercased()
        NotificationCenter.default.post(name: .languageDidChange, object: nil)
    }
}
