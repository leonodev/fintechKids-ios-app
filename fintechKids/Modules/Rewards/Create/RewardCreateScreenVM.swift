//
//  RewardCreateScreenVM.swift
//  fintechKids
//
//  Created by fleon  on 19/5/26.
//

import Foundation
import Observation
import FHKCore
import FHKInjections
import FHKDomain
import FHKFirebase
import FHKUtils

@Observable
final class RewardCreateScreenVM: FHKCore.ViewModel {
    var viewState: RewardCreateViewState = .init()
    
    // Properties injected
    private var fhkRewardsRepository: any FHKRewardRepositoryProtocol {
        inject.fhkRewardsRepository
    }
    
    private var fhkConfiguration: any FHKConfigurationProtocol {
        inject.fhkConfiguration
    }
    
    private var fhkFirebaseAnalitycs: any FHKAnalyticsProtocol {
        inject.fhkFirebaseAnalitycs
    }
    
    public var fhkToast: any FHKToastProtocol {
        inject.fhkToast
    }
    
    public var fhkModal: any FHKModalProtocol {
        inject.fhkModal
    }
    
    public enum Action: Equatable {
        case createReward(reward: RewardEntity)
    }
    
    @MainActor
    public func action(_ action: Action) async {
        switch action {
            
        case .createReward(let reward):
            await createReward(reward: reward)
        }
    }
    
    func getParentMail() -> String? {
        fhkConfiguration.parentMail
    }
    
    func displayNotification(message: String, type: ToastType = .warning) {
        fhkToast.show(info: viewState.toastInfo(msn: message, type: type))
    }
}

private extension RewardCreateScreenVM {
    
    func createReward(reward: RewardEntity) async {
        do {
            viewState.createState = .loading
            try await fhkRewardsRepository.createReward(reward: reward)
            viewState.createState = .finish(result: .success)
        } catch {
            informateError(FHKRewardError.createRewardFailed)
            viewState.createState = .finish(result: .error)
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
