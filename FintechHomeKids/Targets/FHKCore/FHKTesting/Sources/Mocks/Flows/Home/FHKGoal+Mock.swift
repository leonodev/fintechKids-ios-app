//
//  FHKGoal+Mock.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import FHKDomain

public extension FHKGoal {
    
    static var test: Self {
        Self()
    }
    
    static var preview: Self {
        var goals = Self()
        
        goals.createGoal = { _ in }
        goals.getGoals = { emailParent in
            FHKGoalEntity.previewItem(2)
        }
        
        return goals
    }
}
