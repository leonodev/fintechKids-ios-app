//
//  GoalListScreenVM.swift
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
final class GoalListScreenVM: FHKCore.ViewModel {
    var viewState: GoalListViewState = .init()
    
    // Properties Injected
    private var fhkGoalsRepository: any FHKGoalRepositoryProtocol {
        inject.fhkGoalsRepository
    }
    
    private var fhkConfiguration: any FHKConfigurationProtocol {
        inject.fhkConfiguration
    }
    
    private var fhkFirebaseAnalitycs: any FHKAnalyticsProtocol {
        inject.fhkFirebaseAnalitycs
    }
    
    public enum Action: Equatable {
        case fetchGoals(force: Bool = false)
    }
    
    @MainActor
    public func action(_ action: Action) async {
        switch action {
            
        case .fetchGoals(let force):
            await fetchGoalList(force: force)
        }
    }
}

private extension GoalListScreenVM {
    
    func fetchGoalList(force: Bool) async {
        viewState.goalListState = .loading
        
        do {
            guard let emailParent = fhkConfiguration.parentMail else {
                viewState.goalListState = .finish(result: .error)
                return
            }
            
            let goalList = try await fhkGoalsRepository.getGoals(emailParent: emailParent, forceRefresh: force)
            viewState.goalList = goalList
            viewState.goalListState = .finish(result: .success)
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
