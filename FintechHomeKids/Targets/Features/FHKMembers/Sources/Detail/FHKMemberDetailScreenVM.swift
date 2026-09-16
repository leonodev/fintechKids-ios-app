//
//  FHKMemberDetailScreenVM.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 15/9/26.
//

import Foundation
import Observation
import FHKCore
import FLibInjections
import FHKDomain
import FLibUtils

@Observable
final class FHKMemberDetailScreenVM: FHKCore.ViewModel {
    
    var viewState: FHKMemberDetailState = .init()
    
    // Properties injected
    private var fhkBalanceRepository: FHKBalanceRepository {
        inject.fhkBalanceRepository
    }
    
    private var fhkHomeRepository: FHKHomeRepository {
        inject.fhkHomeRepository
    }
    
    private var fhkAnalitycs: FHKAnalytics {
        inject.fhkAnalitycs
    }
    
    public enum Action: Equatable {
        case getMemberBy(memberId: UUID)
    }
    
    @MainActor
    public func action(_ action: Action) async {
        switch action {
            
        case .getMemberBy(let memberId):
            await getMember(memberId: memberId)
        }
    }
}

private extension FHKMemberDetailScreenVM {
    func getMember(memberId: UUID) async {
        
        async let member = getInfoMember(memberId)
        async let balance = getBalanceMember(memberId)
        
        let (fetchedMember, fetchedBalance) = await (member, balance)
        viewState.member = fetchedMember
        viewState.balance = fetchedBalance
        viewState.memberState = .loaded
    }
    
    func getInfoMember(_ memberId: UUID) async -> FHKMemberEntity? {
        do {
            let infoMember = try await fhkHomeRepository.getMemberById(memberId)
            return infoMember
        } catch {
            informateError(FHKMembersError.getMemberByIdFailed)
            viewState.memberState = .finish(result: .error)
            return nil
        }
    }
    
    func getBalanceMember(_ memberId: UUID) async -> FHKBalanceEntity? {
        do {
            let balanceMember = try await fhkBalanceRepository.fetchBalance(memberId)
            return balanceMember
        } catch {
            informateError(FHKMembersError.getBalanceFailed)
            viewState.memberState = .finish(result: .error)
            return nil
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
