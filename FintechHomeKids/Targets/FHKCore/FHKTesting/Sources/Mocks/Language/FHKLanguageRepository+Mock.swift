//
//  FHKLanguageRepository+Mock.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 30/8/26.
//

import Foundation
import FHKCore

public extension FHKLanguageRepository {
    
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
