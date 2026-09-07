//
//  FHKLanguageRepository.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 28/8/26.
//

import FLibInjections

public struct FHKLanguageRepository: Sendable {
    public var fetchConfig: @Sendable() async -> [String] = { [] }
    public var changeLanguageApp: @Sendable(String) async -> Void = { _ in }
    
    public init() {}
}

public extension DependenciesInjection {
    
    var fhkLanguageRepository: FHKLanguageRepository {
        get { get(FHKLanguageRepository.self, preview: .preview, testing: .test) }
        set { set(newValue, for: FHKLanguageRepository.self) }
    }
}

#if DEBUG

extension FHKLanguageRepository {
    
    static var test: Self {
        Self()
    }
    
    static var preview: Self {
        var mock = Self()
        
        mock.fetchConfig = {
            ["es", "it", "en", "fr"]
        }
        
        mock.changeLanguageApp = { _ in }
        
        return mock
    }
}


#endif

