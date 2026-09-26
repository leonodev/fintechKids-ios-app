//
//  FHKRewardCreateScreenVM.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 26/9/26.
//

import Foundation
import Observation
import FHKCore
import FLibInjections
import FHKDomain
import FLibUtils

@Observable
final class FHKRewardCreateScreenVM: FHKCore.ViewModel {
    var viewState: FHKRewardCreateViewState = .init()
    
    // Properties injected
    private var fhkRewardsRepository: FHKRewardRepository {
        inject.fhkRewardRepository
    }
    
    private var fhkConfiguration: FHKConfiguration {
        inject.fhkConfiguration
    }
    
    private var fhkAnalitycs: FHKAnalytics {
        inject.fhkAnalitycs
    }
    
    public var fhkToast: FHKToast {
        inject.fhkToast
    }
    
    public var fhkModal: FHKModal {
        inject.fhkModal
    }
    
    public enum Action: Equatable {
        case createReward(reward: FHKRewardEntity)
    }
    
    @MainActor
    public func action(_ action: Action) async {
        switch action {
            
        case .createReward(let reward):
            await createReward(reward: reward)
        }
    }
    
    func getParentMail() -> String? {
        fhkConfiguration.parentMail()
    }
    
    func displayNotification(message: String, type: ToastType = .warning) {
        fhkToast.show(viewState.toastInfo(msn: message, type: type))
    }
}

private extension FHKRewardCreateScreenVM {
    
    func createReward(reward: FHKRewardEntity) async {
        do {
            viewState.createState = .loading
            try await fhkRewardsRepository.createReward(reward)
            viewState.createState = .finish(result: .success)
        } catch {
            informateError(FHKRewardError.createRewardFailed)
            viewState.createState = .finish(result: .error)
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
