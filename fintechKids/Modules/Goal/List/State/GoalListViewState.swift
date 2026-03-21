//
//  GoalListViewState.swift
//  fintechKids
//
//  Created by Fredy Leon on 20/3/26.
//


import Observation
import FHKUtils
import FHKDomain
import FHKDesignSystem

@Observable
public class GoalListViewState {
    // Properties Observable
   
    public var msnLoading: String {
        "loading".localized().capitalizingFirstLetter()
    }
    
    public func getLottieAnimation(measureType: String) -> String {
        if measureType.lowercased() == WorkType.time.value.lowercased() {
            return Lotties.hours
        } else {
            return Lotties.coin
        }
    }
    
    public var msnUserError: String = ""
    
    public enum State: Equatable {
        case loading
        case loaded
        case finish(result: ActionResult)
    }
    
    public var goalListState: State = .loaded
    public var goalList: [GoalEntity] = []
}
