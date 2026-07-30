//
//  FHKGoalListScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 20/3/26.
//

import Foundation
import Observation
import FHKCore
import FHKInjections
import FHKDomain
import FHKFirebase
import FHKUtils

@Observable
final class FHKGoalListScreenVM: FHKCore.ViewModel {
    var viewState: FHKGoalListViewState = .init()
    
    // Properties Injected
    private var fhkGoalsRepository: FHKGoalRepository {
        inject.fhkGoalsRepository
    }
    
    private var fhkConfiguration: FHKConfiguration {
        inject.fhkConfiguration
    }
    
    private var fhkFirebaseAnalitycs: FHKAnalytics {
        inject.fhkFirebaseAnalitycs
    }
    
    public enum Action: Equatable {
        case fetchGoals(force: Bool = false)
    }
    
    @MainActor
    public func action(_ action: Action) async {
        switch action {
            
        case .fetchGoals(let isForce):
            await fetchGoalList(isForce: isForce)
        }
    }
}

private extension FHKGoalListScreenVM {
    
    func fetchGoalList(isForce: Bool) async {
        do {
            guard let emailParent = fhkConfiguration.parentMail() else {
                viewState.goalListState = .finish(result: .error)
                return
            }
            
            viewState.goalListState = .loading
            let goalList = try await fhkGoalsRepository.getGoals(emailParent, isForce)
            viewState.goalList = goalList
            viewState.goalListState =  !viewState.goalList.isEmpty ? .finish(result: .success) : .empty
        } catch {
            informateError(FHKGoalError.fetchListGoalFailed)
            viewState.goalListState = .finish(result: .error)
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
