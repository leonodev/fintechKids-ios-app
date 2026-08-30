//
//  FHKLanguage.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 27/8/26.
//

import SwiftUI

public struct FHKLanguage: Sendable {
    public var selectedLanguage: @MainActor @Sendable () -> String = { LanguageType.es.code }
    public var setSelectedLanguage: @MainActor @Sendable (String) -> Void = { _ in }
    public var currentBundle: @MainActor @Sendable () -> Bundle = { .main }
    
    public var changeLanguage: @MainActor @Sendable(String) -> Void = {  _ in }
    public var languageTypeFromCode: @MainActor @Sendable (String) -> LanguageType = { _ in .es }
    
    public init() {}
}

public enum LanguageType: String, Sendable, Codable, Equatable {
    case en = "en"
    case es = "es"
    case it = "it"
    case fr = "fr"
    
    public var code: String {
        return self.rawValue
    }
    
    public var name: String {
        switch self {
        case .es:
            return "Español"
        case .en:
            return "English"
        case .it:
            return "Italiano"
        case .fr:
            return "Français"
        }
    }
    
    public static func == (lhs: LanguageType, rhs: LanguageType) -> Bool {
        lhs.code == rhs.code
    }
}
