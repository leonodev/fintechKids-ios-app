//
//  FHKTasksScreenVM.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 27/9/26.
//

import Foundation
import Observation
import FHKCore
import FLibInjections
import FHKDomain
import FLibUtils

@Observable
final class FHKTasksScreenVM: FHKCore.ViewModel {
    var viewState: FHKTasksViewState = .init()
    
    // Properties Injected
    private var fhkConfiguration: FHKConfiguration {
        inject.fhkConfiguration
    }
    
    private var fhkTasksRepository: FHKTasksRepository {
        inject.fhkTasksRepository
    }
    
    private var fhkAnalitycs: FHKAnalytics {
        inject.fhkAnalitycs
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

private extension FHKTasksScreenVM {
    
    func createNewTask() async {
        viewState.taskState = .loading
        
        do {
            guard let emailParent = fhkConfiguration.parentMail() else {
                viewState.taskState = .finish(result: .error)
                return
            }
            
            //@comentado
            let task = FHKTaskEntity(createdAt: Date().toUTC,
                                     name: "Limpiar",
                                     description: "my description",
                                     timeGranted: "1 days",
                                     coinsGranted: 10,
                                     emailParent: emailParent)
            
            try await fhkTasksRepository.createTask(task)
            await fetchTasksList(force: true)
            viewState.taskState = .finish(result: .success)
        } catch {
            informateError(FHKTaskError.createTaskFailed)
            viewState.taskState = .finish(result: .error)
        }
    }
    
    func fetchTasksList(force: Bool) async {
        viewState.taskState = .loading
        
        do {
            guard let emailParent = fhkConfiguration.parentMail() else {
                viewState.taskState = .finish(result: .error)
                return
            }
            
            let taskList = try await fhkTasksRepository.getTasks(emailParent, force)
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
            fhkAnalitycs.track(.error(.init(from: error)))
        }
        
        // We show the user the localized message (UX)
        viewState.msnUserError = error.msnLocalizedKey.localized
        
        // We print the full details to the console (Debug)
        Logger.error(error.logMessage)
    }
}
