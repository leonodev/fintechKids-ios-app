//
//  FHKHomeScreenVM.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import Foundation
import Observation
import FHKCore
import FHKDomain
import FHKDesignSystem
import FLibInjections

@Observable
final class FHKHomeScreenVM: FHKCore.ViewModel {
    var viewState: FHKHomeViewState = .init()
    
    // Properties Injection
    private var fhkHomeRepository: FHKHomeRepository {
        inject.fhkHomeRepository
    }
    
    private var fhkGoalsRepository: FHKGoalRepository {
        inject.fhkGoalsRepository
    }
    
    private var fhkRemoteConfig: FHKRemoteConfig {
        inject.fhkRemoteConfig
    }
    
    public var fhkToast: FHKToast {
        inject.fhkToast
    }
    
//    public var fhkCameraPermission: FHKPermission {
//        inject.fhkCameraPermission
//    }
    
    public init() {}
    
    enum Action: Equatable {
        case registerUser
    }
    
    @MainActor
    func action(_ action: Action) async {
        
    }
}
