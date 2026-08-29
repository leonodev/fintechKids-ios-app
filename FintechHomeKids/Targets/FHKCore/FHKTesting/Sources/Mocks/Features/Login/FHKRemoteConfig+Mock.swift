//
//  FHKRemoteConfig+Mock.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 29/8/26.
//

import FHKCore

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
