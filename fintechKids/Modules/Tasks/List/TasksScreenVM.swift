//
//  TasksScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 20/12/25.
//

import Foundation
import Observation
import FHKCore
import FHKInjections
import FHKDomain
import FHKFirebase
import FHKUtils

@Observable
final class TasksScreenVM: FHKCore.ViewModel {
    var viewState: TasksViewState = .init()
    
    // Properties Injected
    private var fhkTasksRepository: any FHKTasksRepositoryProtocol {
        inject.fhkTasksRepository
    }
    
    private var fhkConfiguration: any FHKConfigurationProtocol {
        inject.fhkConfiguration
    }
    
    private var fhkFirebaseAnalitycs: any FHKAnalyticsProtocol {
        inject.fhkFirebaseAnalitycs
    }
    
    public enum Action: Equatable {
        case fetchTasks(force: Bool = false)
        case createTask
    }
    
    @MainActor
    public func action(_ action: Action) async {
        switch action {
            
        case .fetchTasks(let force):
            await fetchTasksList(force: force)
            
        case .createTask:
            await createNewTask()
        }
    }
}

private extension TasksScreenVM {
    
    func createNewTask() async {
        viewState.taskState = .loading
        
        do {
            guard let emailParent = fhkConfiguration.parentMail else {
                viewState.taskState = .finish(result: .error)
                return
            }
            
            let task = TaskEntity(createdAt: Date().toUTC,
                                  name: "Limpiar",
                                  description: "my description",
                                  timeGranted: "1 days",
                                  coinsGranted: 10,
                                  emailParent: emailParent)
            
            try await fhkTasksRepository.createTask(task: task)
            await fetchTasksList(force: true)
            viewState.taskState = .finish(result: .success)
        } catch {
            informateError(FHKAppError.addMembersFailed)
            viewState.taskState = .finish(result: .error)
        }
    }
    
    func fetchTasksList(force: Bool) async {
        viewState.taskState = .loading
        
        do {
            guard let emailParent = fhkConfiguration.parentMail else {
                viewState.taskState = .finish(result: .error)
                return
            }
            
            let taskList = try await fhkTasksRepository.getTasks(emailParent: emailParent, forceRefresh: force)
            viewState.taskList = taskList
            viewState.taskState = .finish(result: .success)
        } catch {
            informateError(FHKAppError.addMembersFailed)
            viewState.taskState = .finish(result: .error)
        }
    }
    
    func informateError(_ error: any FHKError) {
        if error.isShouldTrack {
            fhkFirebaseAnalitycs.track(.error(.init(from: error)))
        }
        
        viewState.msnUserError = error.messageUI
        Logger.error(error.logMessage)
    }
}
