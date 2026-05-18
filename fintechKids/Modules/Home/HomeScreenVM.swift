//
//  HomeScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 21/1/26.
//

import Foundation
import Observation
import FHKCore
import FHKInjections
import FHKDomain
import FHKDesignSystem

@Observable
final class HomeScreenVM: FHKCore.ViewModel {
    var viewState: HomeViewState = .init()
    
    // Properties Injection
    private var fhkHomeRepository: FHKHomeRepositoryProtocol {
        inject.fhkHomeRepository
    }
    
    private var fhkGoalsRepository: any FHKGoalRepositoryProtocol {
        inject.fhkGoalsRepository
    }
    
    public var fhkToast: any FHKToastProtocol {
        inject.fhkToast
    }
    
    public var fhkCameraPermission: any FHKPermissionProtocol {
        inject.fhkCameraPermission
    }
    
    // Other Properties
    public var familyMembersList: [MemberEntity] = []
    public var rewardsCollectedList: [RewardCollectedEntity] = []
    public var goalMemberList: [GoalMemberEntity] = []
    
    enum Action: Equatable {
        case fetchMemberFamily(force: Bool = false)
        case fetchRewardsCollected(force: Bool = false)
        case fetchMemberGoals(force: Bool = false)
    }
    
    func getParentMail() async {
        let email = await fhkHomeRepository.getParentMail()
        viewState.parentEmail = email
    }
    
    @MainActor
    func action(_ action: Action) async {
        switch action {
        case .fetchMemberFamily(let force):
            await fetchMemberFamily(force: force)
            
        case .fetchRewardsCollected(let force):
            await fetchRewardsCollected(force: force)
            
        case .fetchMemberGoals(let force):
            await fetchGoalMember(force: force)
        }
    }
    
    private func fetchMemberFamily(force: Bool) async {
        viewState.familyState = .skeleton
        
        do {
            guard let email = viewState.parentEmail else {
                showNotificationError(msn: viewState.errorRecoveryInfoUser)
                viewState.familyState = .defaultDataError
                return
            }

            let members = try await fhkHomeRepository.fetchMembers(email: email, forceRefresh: force)
            familyMembersList = members
            viewState.familyState = .loaded
        } catch {
            viewState.familyState = .defaultDataError
            showNotificationError(msn: viewState.errorFetchMembers)
        }
    }
    
    private func fetchRewardsCollected(force: Bool) async {
        viewState.rewardsState = .skeleton
        do {
            guard let email = viewState.parentEmail else {
                showNotificationError(msn: viewState.errorRecoveryInfoUser)
                viewState.rewardsState = .defaultDataError
                return
            }

            let rewardsCollected = try await fhkHomeRepository.fetchRewardCollected(parentEmail: email,
                                                                                        forceRefresh: force)
            rewardsCollectedList = rewardsCollected
            viewState.rewardsState = .loaded
        } catch {
            viewState.rewardsState = .defaultDataError
            showNotificationError(msn: viewState.errorRewardCollect)
        }
    }
    
    private func fetchGoalMember(force: Bool) async {
        viewState.goalMemberState = .skeleton
        do {
            guard let email = viewState.parentEmail else {
                showNotificationError(msn: viewState.errorRecoveryInfoUser)
                viewState.rewardsState = .defaultDataError
                return
            }

            let goalMember = try await fhkGoalsRepository.fetchGoalMemberFamily(emailParent: email,
                                                                                forceRefresh: force)
            goalMemberList = goalMember
            viewState.goalMemberState = .loaded
        } catch {
            viewState.goalMemberState = .defaultDataError
            showNotificationError(msn: viewState.msnErrorFetchGoalList)
        }
    }
    
    func getNameMember(member: MemberEntity) -> String {
        member.memberName
    }
    
    func getAvatarMember(member: MemberEntity) -> String {
        member.avatarName
    }
    
    func getId(member: MemberEntity) -> UUID {
        member.id
    }
}

private extension HomeScreenVM {
    func showNotificationError(msn: String) {
        fhkToast.show(info: FHKToastInfo(
            type: .error,
            message: msn,
            hasIcon: true)
        )
    }
}
