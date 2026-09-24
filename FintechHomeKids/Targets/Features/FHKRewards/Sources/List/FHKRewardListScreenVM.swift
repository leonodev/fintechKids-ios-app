//
//  FHKRewardListScreenVM.swift
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
final class FHKRewardListScreenVM: FHKCore.ViewModel {
    var viewState: FHKRewardListViewState = .init()
    
    // Properties Injected
    private var fhkConfiguration: FHKConfiguration {
        inject.fhkConfiguration
    }
    
    private var fhkRewardRepository: FHKRewardRepository {
        inject.fhkRewardRepository
    }
    
    private var fhkAnalitycs: FHKAnalytics {
        inject.fhkAnalitycs
    }
    
    public enum Action: Equatable {
        case fetchRewards(force: Bool = false)
    }
    
    @MainActor
    public func action(_ action: Action) async {
        switch action {
            
        case .fetchRewards(let force):
            await fetchRewardList(force: force)
        }
    }
}

private extension FHKRewardListScreenVM {
    
    func fetchRewardList(force: Bool) async {
        do {
            guard let emailParent = fhkConfiguration.parentMail() else {
                viewState.rewardListState = .finish(result: .error)
                return
            }
            
            viewState.rewardListState = .loading
            let rewardList = try await fhkRewardRepository.fetchRewards(emailParent, force)
            viewState.rewardList = rewardList
            viewState.rewardListState =  !viewState.rewardList.isEmpty ? .finish(result: .success) : .empty
        } catch {
            informateError(FHKRewardError.fetchListRewardFailed)
            viewState.rewardListState = .finish(result: .error)
        }
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
