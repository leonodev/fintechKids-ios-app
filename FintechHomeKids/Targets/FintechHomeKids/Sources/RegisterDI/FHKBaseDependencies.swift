//
//  FHKBaseDependencies.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 25/8/26.
//

import Foundation
import Supabase
import FLibInjections
import FLibStorage
import Core
import Domain

public class FHKBaseDependencies {
    
    @MainActor
    public static func register() throws {
        
        inject.register(FHKStorageManager.self,
                        live: { .live(userDefault: FHKUserDefault(),
                                      keychain: FHKKeychainStorage()) }
        )
    }
}
