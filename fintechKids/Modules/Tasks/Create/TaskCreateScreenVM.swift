//
//  TaskCreateScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 14/3/26.
//

import Foundation
import Observation
import FHKCore
import FHKInjections
import FHKDomain
import FHKFirebase
import FHKUtils

@Observable
final class TaskCreateScreenVM: FHKCore.ViewModel {
    var viewState: TaskCreateViewState = .init()
    
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
    
    public var fhkModal: any FHKModalProtocol {
        inject.fhkModal
    }
    
    public enum Action: Equatable {
        case createTask
    }
    
    @MainActor
    public func action(_ action: Action) async {
        switch action {
            
        case .createTask:
            await createNewTask()
        }
    }
}

private extension TaskCreateScreenVM {
    
    func createNewTask() async {
        viewState.taskCreateState = .loading
        
        do {
            guard let emailParent = fhkConfiguration.parentMail else {
                informateError(FHKAppError.readUserMailKeychainFailed)
                viewState.taskCreateState = .finish(result: .error)
                return
            }
            
            guard let mesuareDuration = viewState.selectedDuration else {
                return
            }
            
            let task = TaskEntity(createdAt: Date().toUTC,
                                  name: viewState.taskName,
                                  description: viewState.taskDescription,
                                  timeGranted: "\(viewState.rewardsTime) \(mesuareDuration)",
                                  coinsGranted: Int(viewState.rewardsKidsCoin) ?? 0,
                                  emailParent: emailParent)
            
            try await fhkTasksRepository.createTask(task: task)
            viewState.taskCreateState = .finish(result: .success)
        } catch let error as FHKSupabaseError {
            viewState.taskCreateState = .finish(result: .error)
            informateError(error)
        } catch {
            informateError(FHKTaskError.createTaskFailed)
            viewState.taskCreateState = .finish(result: .error)
        }
    }
    
    func informateError(_ error: any FHKError) {
        if error.isShouldTrack {
            fhkFirebaseAnalitycs.track(.error(.init(from: error)))
        }
        
        viewState.msnUserError = error.messageLocalized
        Logger.error(error.logMessage)
    }
}
