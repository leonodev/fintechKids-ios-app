//
//  TaskError.swift
//  fintechKids
//
//  Created by Fredy Leon on 19/3/26.
//

import FHKUtils
import FHKDomain

enum FHKTaskError: FHKError {
    case createTaskFailed
    case fetchTaskFailed

    var logMessage: String {
        switch self {
        case .createTaskFailed:
            return "Error: creating new task"
            
        case .fetchTaskFailed:
            return "Error: getting task list"
        }
    }
    
    var msnLocalizedKey: String {
        switch self {
        case .createTaskFailed:
            return "msn_error_create_task"
            
        case .fetchTaskFailed:
            return "msn_error_fetch_task_list"
        }
    }
    
    var isShouldTrack: Bool {
        true
    }
}
