//
//  ProfileRepository.swift
//  fintechKids
//
//  Created by Fredy Leon on 8/3/26.
//

import FHKDomain
import FHKInjections
import FHKStorage

final class ProfileRepository: FHKProfileRepositoryProtocol {
    
    // Properties Injected
    private var fhkSupabase: any FHKAuthProtocol {
        inject.fhkSupabase
    }
    
    private var fhkStorage: any FHKStorageManagerProtocol {
        inject.fhkStorage
    }
    
    private var fhkConfiguration: any FHKConfigurationProtocol {
        inject.fhkConfiguration
    }
    
    private var fhkLanguage: any FHKLanguageManagerProtocol {
        inject.fhkLanguage
    }
    
    func logout() async throws {
        try await fhkSupabase.logout()
    }
    
    func deleteKeychain(key: String) throws {
        try fhkStorage.deleteKeychain(key)
    }
    
    func getEmailParent() throws -> String? {
        fhkConfiguration.parentMail
    }
    
    func getLanguageCurrent() async -> String {
        let language = try? await fhkStorage.readUserDefaults(String.self, forKey: UserDefaultsKeys.languageKey)
        return language ?? LanguageType.es.code
    }
    
    func setNewLanguage(lang: String) {
        fhkLanguage.changeLanguage(to: lang)
    }
    
    public func getFamilyName() async -> String? {
        fhkConfiguration.refreshFamilyName()
        return fhkConfiguration.familyName
    }
}
