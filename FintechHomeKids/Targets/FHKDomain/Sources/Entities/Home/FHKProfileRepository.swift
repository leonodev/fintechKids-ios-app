//
//  FHKProfileRepository.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 15/9/26.
//

import Foundation
import FLibInjections
import FHKCore

// MARK: - Contract
public struct FHKProfileRepository: Sendable {
    
    public var logout:
    @Sendable() async throws -> Void = { }
    
    public var deleteKeychain:
    @Sendable(String) throws -> Void = { _ in }
    
    public var getEmailParent:
    @Sendable() throws -> String? = { nil }
    
    public var getLanguageCurrent:
    @Sendable() async -> String = { LanguageType.en.code }
    
    public var setNewLanguage:
    @Sendable @MainActor(String) -> Void = { _ in }
    
    public var getFamilyName:
    @Sendable() async -> String? = { nil }
    
    public init() {}
}

// MARK: - KeyPath Access
public extension DependenciesInjection {
    
    var fhkProfileRepository: FHKProfileRepository {
        get { get(FHKProfileRepository.self, preview: .preview, testing: .test) }
        set { set(newValue, for: FHKProfileRepository.self) }
    }
}


// MARK: - Mocks & Previews
#if DEBUG
extension FHKProfileRepository {
    static var test: Self {
        Self()
    }
    
    static var preview: Self {
        var preview = Self()
        
        preview.logout = {}
        preview.deleteKeychain = { _ in }
        preview.getEmailParent = {
            return "parent@domain.com"
        }
        
        preview.getLanguageCurrent = {
            return LanguageType.en.code
        }
        
        preview.setNewLanguage = { _ in }
        preview.getFamilyName = {
            return "Family Name"
        }
        
        return preview
    }
}

#endif
