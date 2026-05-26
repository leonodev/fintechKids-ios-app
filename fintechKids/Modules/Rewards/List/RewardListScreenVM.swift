//
//  RewardListScreenVM.swift
//  fintechKids
//
//  Created by fleon  on 25/5/26.
//

import Foundation
import Observation
import FHKCore
import FHKInjections
import FHKDomain
import FHKFirebase
import FHKUtils

@Observable
final class RewardListScreenVM: FHKCore.ViewModel {
    var viewState: RewardListViewState = .init()
    
    // Properties Injected
    private var fhkConfiguration: any FHKConfigurationProtocol {
        inject.fhkConfiguration
    }
    
    private var fhkRewardsRepository: any FHKRewardRepositoryProtocol {
        inject.fhkRewardsRepository
    }
    
    private var fhkFirebaseAnalitycs: any FHKAnalyticsProtocol {
        inject.fhkFirebaseAnalitycs
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

private extension RewardListScreenVM {
    
    func fetchRewardList(force: Bool) async {
        do {
            guard let emailParent = fhkConfiguration.parentMail else {
                viewState.rewardListState = .finish(result: .error)
                return
            }
            
            viewState.rewardListState = .loading
            let rewardList = try await fhkRewardsRepository.fetchRewards(emailParent: emailParent, forceRefresh: force)
            viewState.rewardList = rewardList
            viewState.rewardListState =  !viewState.rewardList.isEmpty ? .finish(result: .success) : .empty
        } catch {
            informateError(FHKRewardError.fetchListRewardFailed)
            viewState.rewardListState = .finish(result: .error)
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
