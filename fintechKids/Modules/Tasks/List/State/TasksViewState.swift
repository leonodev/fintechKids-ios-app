//
//  TasksViewState.swift
//  fintechKids
//
//  Created by Fredy Leon on 12/3/26.
//

import Observation
import FHKUtils
import FHKDomain

@Observable
public class TasksViewState {
    // Properties Observable
   
    public var msnLoading: String {
        "loading".localized().capitalizingFirstLetter()
    }
    
    public var msnUserError: String = ""
    
    public enum State: Equatable {
        case loading
        case loaded
        case finish(result: ActionResult)
    }
    
    public var taskState: State = .loaded
    public var taskList: [TaskEntity] = []
}
