//
//  DependenciesInjection+Home.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import Foundation
import FLibInjections
import FHKCore
import FHKDomain

public extension DependenciesInjection {
    
    var fhkGoal: FHKGoal {
        get { get(FHKGoal.self) }
        set { set(newValue, for: FHKGoal.self) }
    }
    
    var fhkHomeRepository: FHKHomeRepository {
        get { get(FHKHomeRepository.self) }
        set { set(newValue, for: FHKHomeRepository.self) }
    }
    
    var fhkGoalsRepository: FHKGoalRepository {
        get { get(FHKGoalRepository.self) }
        set { set(newValue, for: FHKGoalRepository.self) }
    }
    
 
    // It only records what lives natively in Feature Home
    static func registerHomeFeature() {
        
    }
}
