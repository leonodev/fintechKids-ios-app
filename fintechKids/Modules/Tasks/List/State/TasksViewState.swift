//
//  TasksViewState.swift
//  fintechKids
//
//  Created by Fredy Leon on 12/3/26.
//

import Observation
import FHKUtils
import FHKDomain
import FHKDesignSystem
import SwiftUI

@Observable
public class TasksViewState {
    // Properties Observable
   
    public var msnLoading: String {
        "loading".localized().capitalizingFirstLetter()
    }
    
    public var titleInTime: String {
        "title_in_time".localized().capitalizingFirstLetter()
    }
    
    public var titleInCoins: String {
        "title_in_coins".localized().capitalizingFirstLetter()
    }
    
    var coinSingle: Image = .coinSingle
    
    public var msnUserError: String = ""
    
    public enum State: Equatable {
        case loading
        case loaded
        case finish(result: ActionResult)
    }
    
    public var taskState: State = .loaded
    public var taskList: [TaskEntity] = []
}
