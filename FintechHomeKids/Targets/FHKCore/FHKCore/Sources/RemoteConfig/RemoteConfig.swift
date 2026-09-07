//
//  FHKRemoteConfig.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 28/8/26.
//

import FLibInjections

public struct FHKRemoteConfig: Sendable {
    public var enabledLanguages: @Sendable() -> [String] = { [] }
    public var menuHomeItems: @Sendable() -> [MenuHomeItem] = { [] }
    public var fetchConfig: @Sendable() async throws -> Void = { }
    public var getCachedTimeExpiration: @Sendable() async -> Int = { 3 /* Minutes */ }
    
    public init() {}
}

public extension DependenciesInjection {
    var fhkRemoteConfig: FHKRemoteConfig {
        get { get(FHKRemoteConfig.self, preview: .preview, testing: .test) }
        set { set(newValue, for: FHKRemoteConfig.self) }
    }
}

#if DEBUG
public extension FHKRemoteConfig {
    static var test: Self {
        Self()
    }
    
    static var preview: Self {
        var config = Self()
        
        config.enabledLanguages = { ["en", "es"] }
        
        config.menuHomeItems = { [
            MenuHomeItem.previewItem
        ]
        }
        
        config.fetchConfig = {}
        
        config.getCachedTimeExpiration = { 1 /* Minutes */  }
        
        return config
    }
}

extension MenuHomeItem {
    static var previewItem: Self {
        MenuHomeItem(id: 1,
                     name: "payments",
                     icon: "payments-icon",
                     label_localized_key: "key_payments_title",
                     active: true)
    }
}
#endif
