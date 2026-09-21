//
//  FHKGoalListScreenVM.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 21/9/26.
//

import Foundation
import Observation
import FHKCore
import FLibInjections
import FHKDomain
import FLibUtils

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
    
    private var fhkAnalitycs: FHKAnalytics {
        inject.fhkAnalitycs
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
    
    func fetchGoalList(force: Bool) async {
        do {
            guard let emailParent = getParentMail() else {
                viewState.goalListState = .finish(result: .error)
                return
            }
            
            
            viewState.goalListState = .loading
            let goalList = try await fhkGoalsRepository.getGoals(emailParent, force)
            viewState.goalList = goalList
            viewState.goalListState = !viewState.goalList.isEmpty
            ? .finish(result: .success)
            : .empty
        } catch {
            informateError(FHKGoalError.fetchListGoalFailed)
            viewState.goalListState = .finish(result: .error)
        }
    }
}

extension FHKGoalListScreenVM {
    
    func getParentMail() -> String? {
        guard let emailParent = fhkConfiguration.parentMail() else {
            viewState.goalListState = .finish(result: .error)
            return nil
        }
        
        return emailParent
    }
    
    func informateError(_ error: some FHKError) {
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
