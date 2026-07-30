//
//  FHKTasksScreenVM.swift
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
final class FHKTasksScreenVM: FHKCore.ViewModel {
    var viewState: FHKTasksViewState = .init()
    
    // Properties Injected
    private var fhkTasksRepository: FHKTasksRepository {
        inject.fhkTasksRepository
    }
    
    private var fhkConfiguration: FHKConfiguration {
        inject.fhkConfiguration
    }
    
    private var fhkFirebaseAnalitycs: FHKAnalytics {
        inject.fhkFirebaseAnalitycs
    }
    
    public enum Action: Equatable {
        case fetchTasks(force: Bool = false)
        case createTask
    }
    
    @MainActor
    public func action(_ action: Action) async {
        switch action {
            
        case .fetchTasks(let isForce):
            await fetchTasksList(isForce: isForce)
            
        case .createTask:
            await createNewTask()
        }
    }
}

private extension FHKTasksScreenVM {
    
    func createNewTask() async {
        viewState.taskState = .loading
        
        do {
            guard let emailParent = fhkConfiguration.parentMail() else {
                viewState.taskState = .finish(result: .error)
                return
            }
            
            let task = TaskEntity(createdAt: Date().toUTC,
                                  name: "Limpiar",
                                  description: "my description",
                                  timeGranted: "1 days",
                                  coinsGranted: 10,
                                  emailParent: emailParent)
            
            try await fhkTasksRepository.createTask(task)
            await fetchTasksList(isForce: true)
            viewState.taskState = .finish(result: .success)
        } catch let error as FHKSupabaseError {
            viewState.taskState = .finish(result: .error)
            informateError(error)
        } catch {
            informateError(FHKTaskError.createTaskFailed)
            viewState.taskState = .finish(result: .error)
        }
    }
    
    func fetchTasksList(isForce: Bool) async {
        viewState.taskState = .loading
        
        do {
            guard let emailParent = fhkConfiguration.parentMail() else {
                viewState.taskState = .finish(result: .error)
                return
            }
            
            let taskList = try await fhkTasksRepository.getTasks(emailParent, isForce)
            viewState.taskList = taskList
            viewState.taskState = .finish(result: .success)
        } catch {
            informateError(FHKTaskError.fetchTaskFailed)
            viewState.taskState = .finish(result: .error)
        }
    }
    
    func informateError(_ error: any FHKError) {
        // We only send to Firebase if the error is configured to be reported.
        if error.isShouldTrack {
            fhkFirebaseAnalitycs.track(.error(.init(from: error)))
        }
        
        // We show the user the localized message (UX)
        viewState.msnUserError = error.messageLocalized
        
        // We print the full details to the console (Debug)
        Logger.error(error.logMessage)
    }
}
