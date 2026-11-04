//
//  FHKTasksViewState.swift
//  FHKTasks
//
//  Created by Fredy Leon on 27/9/26.
//

import Foundation
import SwiftUI
import FHKDesignSystem
import FHKDomain
import FHKCore

@MainActor
public struct FHKTasksViewState {
    var parentEmail: String?

    public var taskTitle: String {
        "title_tasks".localized.uppercased()
    }
    
    public var taskAvailableTitle: String {
        "title_task_available".localized.uppercased()
    }
    
    public var taskAvailableDescription: String {
        "description_task_available".localized.capitalizingFirstLetter()
    }
    
    public var taskCreateDescription: String {
        "description_create_task_available".localized.capitalizingFirstLetter()
    }
    
    public var taskCreatedParentDescription: String {
        "description_task_created_parents".localized.capitalizingFirstLetter()
    }

    
    public var msnLoading: String {
        "loading".localized.capitalizingFirstLetter()
    }
    
    public var msnUserError: String = ""
    
    public enum State: Equatable {
        case loading
        case loaded
        case finish(result: FHKActionResult)
    }
    
    public var taskState: State = .loaded
    public var taskList: [FHKTaskEntity] = []
}
