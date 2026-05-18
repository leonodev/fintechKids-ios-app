//
//  MemberDetailScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 9/3/26.
//

import Foundation
import Observation
import FHKCore
import FHKInjections
import FHKDomain
import FHKFirebase
import FHKUtils

@Observable
final class MemberDetailScreenVM: FHKCore.ViewModel {
    var viewState: MemberDetailState = .init()
    
    // Properties injected
    private var fhkBalanceRepository: any FHKBalanceRepositoryProtocol {
        inject.fhkBalanceRepository
    }
    
    private var fhkFirebaseAnalitycs: any FHKAnalyticsProtocol {
        inject.fhkFirebaseAnalitycs
    }
    
    public enum Action: Equatable {
        case fetchBalance(memberId: UUID)
    }
    
    @MainActor
    public func action(_ action: Action) async {
        switch action {
            
        case .fetchBalance(let memberId):
            await fetchBalance(memberId: memberId)
        }
    }
}

private extension MemberDetailScreenVM {
    
    func fetchBalance(memberId: UUID) async {
        do {
            viewState.memberState = .loading
            let balance = try await fhkBalanceRepository.fetchBalance(memberId: memberId)
            viewState.balance = balance
            viewState.memberState = .loaded
        } catch {
            informateError(FHKMemberDetailError.getBalanceFailed)
            viewState.memberState = .finish(result: .error)
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
