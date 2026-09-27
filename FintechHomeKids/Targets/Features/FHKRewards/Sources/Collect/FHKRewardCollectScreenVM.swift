//
//  FHKRewardCollectScreenVM.swift
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
final class FHKRewardCollectScreenVM: FHKCore.ViewModel {
    var viewState: FHKRewardCollectViewState = .init()
    
    // Properties injected
    private var fhkBalanceRepository: FHKBalanceRepository {
        inject.fhkBalanceRepository
    }
    
    private var fhkGoalsRepository: FHKGoalRepository {
        inject.fhkGoalsRepository
    }
    
    private var fhkRewardsRepository: FHKRewardRepository {
        inject.fhkRewardRepository
    }
    
    private var fhkConfiguration: FHKConfiguration {
        inject.fhkConfiguration
    }
    
    private var fhkAnalitycs: FHKAnalytics {
        inject.fhkAnalitycs
    }
    
    public var fhkModal: FHKModal {
        inject.fhkModal
    }
    
    public var fhkToast: FHKToast {
        inject.fhkToast
    }
    
    public var parentMail: String? {
        fhkConfiguration.parentMail()
    }
 
    public enum Action: Equatable {
        case fetchGoals(force: Bool = false)
        case fetchMemberGoals(memberId: UUID, force: Bool = false)
        case fetchBalance(memberId: UUID)
        case fetchRewards(force: Bool = false)
        case filterGoals(model: FHKRewardReceivedEntity)
        case updateCoinsBalance(balance: FHKBalanceKidsCoinsEntity)
        case updateTimeBalance(balance: FHKBalanceTimeEntity)
        case collectSendTicketGold(ticket: FHKGoldenTicketParamsEntity)
        case upsertMemberGoal(goalMember: FHKGoalMemberEntity)
        case proccessRemainingBalance(FHKBalanceRemainingEntity)
    }
    
    @MainActor
    public func action(_ action: Action) async {
        switch action {
            
        case .fetchGoals(let force):
            await fetchGoalList(force: force)
            
        case .fetchMemberGoals(let memberId, let force):
            await fetchGoalMember(memberId: memberId, force: force)
            
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
            
        case .upsertMemberGoal(let goalMember):
            await upsertMemberGoal(goalMember: goalMember)
            
        case .proccessRemainingBalance(let remainingBalance):
            await proccessRemainingBalance(balanceRemaining: remainingBalance)
        }
    }
    
    func getGoalMemberEntity(goal: FHKGoalEntity, member: FHKMemberEntity, collect: FHKRewardReceivedEntity) -> FHKGoalMemberEntity? {
        guard let emailParent = fhkConfiguration.parentMail(), let goalID = goal.id else {
            displayNotification(message: viewState.msnCreateGoalMemberDataUncompleted)
            return nil
        }
        
        return FHKGoalMemberEntity(goalId: goalID,
                                   memberId: member.id,
                                   nameGoal: goal.name,
                                   taskWinnedValue: getAccumulatedValue(goal: goal, collectReward: collect),
                                   rewardsSystemType: goal.measureType,
                                   rewardsSystemValue: goal.value,
                                   parentEmail: emailParent)
    }
}

private extension FHKRewardCollectScreenVM {
    
    // get value by send to member goal
    func getAccumulatedValue(goal: FHKGoalEntity, collectReward: FHKRewardReceivedEntity) -> Int {
        let valueTask = viewState.getValueTask(type: collectReward.rewardType, task: collectReward.task)
        
        if valueTask >= goal.value {
            return goal.value
        } else {
            return valueTask
        }
    }
    
    func fetchGoalList(force: Bool) async {
        do {
            guard let emailParent = fhkConfiguration.parentMail() else {
                viewState.collectState = .finish(result: .error)
                return
            }
            
            viewState.collectState = .loading
            let goalList = try await fhkGoalsRepository.getGoals(emailParent, force)
            viewState.goalList = goalList
            viewState.collectState = .loaded
        } catch {
            informateError(FHKRewardError.fetchListGoalFailed)
            viewState.collectState = .finish(result: .error)
        }
    }
    
    func fetchGoalMember(memberId: UUID, force: Bool) async {
        do {
            viewState.collectState = .loading
            let goalMemberList = try await fhkGoalsRepository.fetchGoalMember(memberId, force)
            viewState.goalMemberList = goalMemberList
            viewState.collectState = .loaded
        } catch {
            informateError(FHKRewardError.fetchListMemberGoalFailed)
            viewState.collectState = .finish(result: .error)
        }
    }
    
    func fetchRewards(force: Bool) async {
        do {
            guard let emailParent = fhkConfiguration.parentMail() else {
                viewState.collectState = .finish(result: .error)
                return
            }
            
            viewState.collectState = .loading
            let rewards = try await fhkRewardsRepository.fetchRewards(emailParent, force)
            viewState.rewardCollectList = rewards
            viewState.collectState = .loaded
        } catch {
            informateError(FHKRewardError.fetchListRewardFailed)
            viewState.collectState = .finish(result: .error)
        }
    }
    
    func fetchBalance(memberId: UUID) async {
        do {
            viewState.collectState = .loading
            let balance = try await fhkBalanceRepository.fetchBalance(memberId)
            viewState.balance = balance
            viewState.collectState = .loaded
        } catch {
            informateError(FHKRewardError.fetchBalanceFailed)
            viewState.collectState = .finish(result: .error)
        }
    }
    
    func informateError(_ error: any FHKError) {
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

private extension FHKRewardCollectScreenVM {
    
    func filterGoals(model: FHKRewardReceivedEntity) async {
        var goalFiltered: [FHKGoalEntity] = []
        viewState.goalList = viewState.goalList
        
        if model.rewardType == .coins {
            goalFiltered = viewState.goalList.filteredGoalsWithCoins(lessThan: model.task.coinsGranted)
        } else {
            let timeValue = model.task.timeGranted.asHours
            goalFiltered = viewState.goalList.filteredGoalsWithTime(lessThan: timeValue)
        }
        
        viewState.goalList = goalFiltered
    }
    
    func updateBalanceCoinsMember(balance: FHKBalanceKidsCoinsEntity) async {
        viewState.collectState = .loading
        do {
            try await fhkBalanceRepository.updateKidsCoinsBalance(balance.memberId, balance)
            await fetchBalance(memberId: balance.memberId)
            viewState.collectState = .finish(result: .success)
        } catch {
            handleBalanceError(error)
        }
    }
    
    func updateBalanceTimeMember(balance: FHKBalanceTimeEntity) async {
        viewState.collectState = .loading
        do {
            try await fhkBalanceRepository.updateTimeBalance(balance.memberId, balance)
            await fetchBalance(memberId: balance.memberId)
            viewState.collectState = .finish(result: .success)
        } catch {
            handleBalanceError(error)
        }
    }
    
    func collectSendTicketGolden(ticketData: FHKGoldenTicketParamsEntity) async {
        viewState.collectState = .loading
        do {
            try await fhkBalanceRepository.sendGoldenTicket(ticketData)
            viewState.goldenTicket = FHKGoldenTicketEntity(
                recipientName: ticketData.recipientName,
                taskDescription: ticketData.taskDescription,
                reward: ticketData.reward,
                ticketCode: Utils.numberBarCode)
            viewState.collectState = .finish(result: .success)
        } catch {
            handleBalanceError(error)
        }
    }
    
    func upsertMemberGoal(goalMember: FHKGoalMemberEntity) async {
        viewState.collectState = .loading
        
        do {
            try await fhkGoalsRepository.createGoalMember(goalMember)
            viewState.collectState = .finish(result: .success)
        } catch {
            handleBalanceError(error)
        }
    }
    
    func proccessRemainingBalance(balanceRemaining: FHKBalanceRemainingEntity) async {
        let valueTask = viewState.getValueTask(type: balanceRemaining.collectReward.rewardType, task: balanceRemaining.collectReward.task)
        
        // if has reward remaining
        if valueTask > balanceRemaining.goal.value {
            switch balanceRemaining.collectReward.rewardType {
            case .coins:
                let balanceKidsCoins = FHKBalanceKidsCoinsEntity(
                    memberId: balanceRemaining.memberId,
                    coinsObtained: balanceRemaining.collectReward.task.coinsGranted)
                await updateBalanceCoinsMember(balance: balanceKidsCoins)
                
            case .time:
                let timeValueGranted = balanceRemaining.collectReward.task.timeGranted.asHours - balanceRemaining.goal.value
                let timeMeasureGranted = viewState.getDescriptionType(type: balanceRemaining.collectReward.rewardType)
                let valueToUpdate = "\(timeValueGranted) \(timeMeasureGranted)"
                
                let balanceTime = FHKBalanceTimeEntity(memberId: balanceRemaining.memberId, timeObtained: valueToUpdate)
                await updateBalanceTimeMember(balance: balanceTime)
            }
        } else {
            Logger.info("unnecessary Update Remaining Balance")
        }
    }
    
    func displayNotification(message: String, type: ToastType = .warning) {
        fhkToast.show(viewState.toastInfo(msn: message, type: type))
    }
    
    private func handleBalanceError(_ error: Error) {
        informateError(FHKRewardError.fetchBalanceFailed)
        viewState.collectState = .finish(result: .error)
    }
}

extension Array where Element == FHKGoalEntity {
    func filteredGoalsWithCoins(lessThan min: Int) -> [FHKGoalEntity] {
        self.filter { $0.measureType == FHKWorkType.coins.value && $0.value >= min }
    }
}

extension Array where Element == FHKGoalEntity {
    func filteredGoalsWithTime(lessThan limit: Int) -> [FHKGoalEntity] {
        self.filter { $0.measureType.isTimeUnit && limit >=  $0.value }
    }
}
