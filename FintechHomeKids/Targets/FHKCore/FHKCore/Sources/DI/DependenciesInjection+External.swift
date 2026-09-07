//
//  DependenciesInjection+External.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 3/9/26.
//

import Foundation
import FLibStorage
import FLibInjections

public extension DependenciesInjection {
    
    var fhkStorage: FHKStorageManager {
        get { inject.get(FHKStorageManager.self, preview: .test, testing: .test) }
        set { inject.set(newValue, for: FHKStorageManager.self) }
    }
}
