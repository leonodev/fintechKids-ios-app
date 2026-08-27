//
//  DIKeyPathRegisterBase.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 25/8/26.
//

import Foundation
import Supabase
import FLibInjections
import FLibStorage
import FHKCore
import FHKDomain

public class FHKBaseDependencies {
    
    @MainActor
    public static func register() throws {
        
        inject.register(FHKEnvironment.self,
                        live: { .live }
        )
        
        inject.register(FHKStorageManager.self,
                        live: { .live(userDefault: FHKUserDefault(),
                                      keychain: FHKKeychainStorage()) }
        )
        
        inject.register(FHKSession.self,
                        live: { .live }
        )
        
        inject.register(FHKModal.self,
                        live: { .live }
        )
    }
}
