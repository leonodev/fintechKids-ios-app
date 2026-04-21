//
//  RewardCollectScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 25/3/26.
//

import Foundation
import Observation
import FHKCore
import FHKInjections
import FHKDomain
import FHKFirebase
import FHKUtils

@Observable
final class RewardCollectScreenVM: FHKCore.ViewModel {
    var viewState: RewardCollectViewState = .init()
    
    // Properties injected
    private var fhkBalanceRepository: FHKBalanceRepositoryProtocol {
        inject.fhkBalanceRepository
    }
    
    private var fhkGoalsRepository: any FHKGoalRepositoryProtocol {
        inject.fhkGoalsRepository
    }
    
    private var fhkRewardsRepository: any FHKRewardRepositoryProtocol {
        inject.fhkRewardsRepository
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
    
    public var parentMail: String? {
        fhkConfiguration.parentMail
    }
    
    public enum Action: Equatable {
        case fetchGoals(force: Bool = false)
        case fetchBalance(memberId: UUID)
        case fetchRewards(force: Bool = false)
        case filterGoals(model: CollectRewardModel)
        case updateCoinsBalance(balance: BalanceKidsCoinsEntity)
        case updateTimeBalance(balance: BalanceTimeEntity)
        case collectSendTicketGold(ticket: GoldenTicketParamsEntity)
    }
    
    @MainActor
    public func action(_ action: Action) async {
        switch action {
            
        case .fetchGoals(let force):
            await fetchGoalList(force: force)
            
        case .fetchBalance(let memberId):
            await fetchBalance(memberId: memberId)
            
        case .fetchRewards(let force):
            await fetchRewards(force: force)
            
        case .filterGoals(let model):
            await filterGoals(model: model)
            
        case .updateCoinsBalance(let balance):
            await updateBalanceCoinsMember(balance: balance)
           
        case .updateTimeBalance(let balance):
            await updateBalanceTimeMember(balance: balance)
            
        case .collectSendTicketGold(let ticket):
            await collectSendTicketGolden(ticketData: ticket)
        }
    }
}

private extension RewardCollectScreenVM {
    
    func fetchGoalList(force: Bool) async {
        do {
            guard let emailParent = fhkConfiguration.parentMail else {
                viewState.collectState = .finish(result: .error)
                return
            }
            
            viewState.collectState = .loading
            let goalList = try await fhkGoalsRepository.getGoals(emailParent: emailParent, forceRefresh: force)
            viewState.goalList = goalList
            viewState.collectState =  !viewState.goalList.isEmpty ? .finish(result: .success) : .loaded
        } catch {
            informateError(FHKGoalError.fetchListGoalFailed)
            viewState.collectState = .finish(result: .error)
        }
    }
    
    func fetchRewards(force: Bool) async {
        do {
            guard let emailParent = fhkConfiguration.parentMail else {
                viewState.collectState = .finish(result: .error)
                return
            }
            
            viewState.collectState = .loading
            let rewards = try await fhkRewardsRepository.fetchRewards(emailParent: emailParent,
                                                                      forceRefresh: force)
            viewState.rewardList = rewards
            viewState.collectState = .loaded
        } catch {
            informateError(FHKRewardError.fetchListRewardFailed)
            viewState.collectState = .finish(result: .error)
        }
    }
    
    func fetchBalance(memberId: UUID) async {
        do {
            viewState.collectState = .loading
            let balance = try await fhkBalanceRepository.fetchBalance(memberId: memberId)
            viewState.balance = balance
            viewState.collectState = .loaded
        } catch {
            informateError(FHKBalanceError.fetchBalanceFailed)
            viewState.collectState = .finish(result: .error)
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

private extension RewardCollectScreenVM {
    
    func filterGoals(model: CollectRewardModel) async {
        var goalFiltered: [GoalEntity] = []
        viewState.goalList = viewState.goalList
        
        if model.rewardType == .coins {
            goalFiltered = viewState.goalList.filteredGoalsWithCoins(lessThan: model.task.coinsGranted)
        } else {
            let timeValue = model.task.timeGranted.asHours
            goalFiltered = viewState.goalList.filteredGoalsWithTime(lessThan: timeValue)
        }
        
        viewState.goalList = goalFiltered
    }
    
    func updateBalanceCoinsMember(balance: BalanceKidsCoinsEntity) async {
        viewState.collectState = .loading
        do {
            try await fhkBalanceRepository.updateKidsCoinsBalance(memberId: balance.memberId, infoBalance: balance)
            await fetchBalance(memberId: balance.memberId)
            viewState.collectState = .finish(result: .success)
        } catch {
            handleBalanceError(error)
        }
    }
    
    func updateBalanceTimeMember(balance: BalanceTimeEntity) async {
        viewState.collectState = .loading
        do {
            try await fhkBalanceRepository.updateTimeBalance(memberId: balance.memberId, infoBalance: balance)
            await fetchBalance(memberId: balance.memberId)
            viewState.collectState = .finish(result: .success)
        } catch {
            handleBalanceError(error)
        }
    }
    
    func collectSendTicketGolden(ticketData: GoldenTicketParamsEntity) async {
        viewState.collectState = .loading
        do {
            try await fhkBalanceRepository.sendGoldenTicket(data: ticketData)
            viewState.goldenTicket = GoldenTicketEntity(recipientName: ticketData.recipientName,
                                                        taskDescription: ticketData.taskDescription,
                                                        reward: ticketData.reward,
                                                        ticketCode: Utils.numberBarCode)
            viewState.collectState = .finish(result: .success)
        } catch {
            handleBalanceError(error)
        }
    }
    
    private func handleBalanceError(_ error: Error) {
        if let supabaseError = error as? FHKSupabaseError {
            informateError(supabaseError)
        } else {
            informateError(FHKBalanceError.fetchBalanceFailed)
        }
        viewState.collectState = .finish(result: .error)
    }
}

extension Array where Element == GoalEntity {
    func filteredGoalsWithCoins(lessThan min: Int) -> [GoalEntity] {
        self.filter { $0.measureType == WorkType.coins.value && $0.value >= min }
    }
}

extension Array where Element == GoalEntity {
    func filteredGoalsWithTime(lessThan limit: Int) -> [GoalEntity] {
        self.filter { $0.measureType.isTimeUnit && limit >=  $0.value }
    }
}
