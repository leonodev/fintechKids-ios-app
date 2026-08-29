//
//  FHKStorageManager+Mock.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 25/8/26.
//

import Foundation
import FLibStorage

public extension FHKStorageManager {
    
    static var test: Self {
        var manager = Self()
        let defaultLanguageData = try? JSONEncoder().encode("EN")
        
        // set language read from user
        manager.readUserDefaultsData = { _ in
            return defaultLanguageData
        }
        
        return manager
    }
}
