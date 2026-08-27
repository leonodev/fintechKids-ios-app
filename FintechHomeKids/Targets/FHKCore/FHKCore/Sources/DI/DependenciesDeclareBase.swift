//
//  DependenciesDeclareBase.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 25/8/26.
//

import FLibInjections
import FLibStorage

public extension DependenciesInjection {
    
    var fhkStorage: FHKStorageManager {
        get { get(FHKStorageManager.self) }
        set { set(newValue, for: FHKStorageManager.self) }
    }
    
    var fhkEnvironment: FHKEnvironment {
        get { get(FHKEnvironment.self) }
        set { set(newValue, for: FHKEnvironment.self) }
    }
    
    var fhkSession: FHKSession {
        get { get(FHKSession.self) }
        set { set(newValue, for: FHKSession.self) }
    }
    
    var fhkModal: FHKModal {
        get { get(FHKModal.self) }
        set { set(newValue, for: FHKModal.self) }
    }
}
