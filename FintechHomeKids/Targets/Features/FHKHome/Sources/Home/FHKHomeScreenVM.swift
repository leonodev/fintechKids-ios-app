//
//  FHKHomeScreenVM.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import Foundation
import Observation
import FHKCore
import FHKDomain
import FHKDesignSystem
import FLibInjections

@Observable
final class FHKHomeScreenVM: FHKCore.ViewModel {
    var viewState: FHKHomeViewState = .init()
    
    // Properties Injection
    private var fhkHomeRepository: FHKHomeRepository {
        inject.fhkHomeRepository
    }
    
    private var fhkGoalsRepository: FHKGoalRepository {
        inject.fhkGoalsRepository
    }
    
    private var fhkRemoteConfig: FHKRemoteConfig {
        inject.fhkRemoteConfig
    }
    
    public var fhkToast: FHKToast {
        inject.fhkToast
    }
    
    public var fhkCameraPermission: FHKPermission {
        inject.fhkCameraPermission
    }
    
    
    // Other Properties
    public var familyMembersList: [FHKMemberEntity] = []
    public var rewardsCollectedList: [FHKRewardCollectedEntity] = []
    public var goalMemberList: [FHKGoalMemberEntity] = []
    
    
    public init() {}
    
    enum Action: Equatable {
        case fetchMemberFamily(force: Bool = false)
        case fetchRewardsCollected(force: Bool = false)
        case fetchMemberGoals(force: Bool = false)
        case fetchInformationMenu
    }
    
    func getParentMail() async {
        let email = await fhkHomeRepository.getParentMail()
        viewState.parentEmail = email
    }
    
    @MainActor
    func action(_ action: Action) async {
        switch action {
        case .fetchMemberFamily(let isRefresh):
            await fetchMemberFamily(isRefresh: isRefresh)
            
        case .fetchRewardsCollected(let isRefresh):
            await fetchRewardsCollected(isRefresh: isRefresh)
            
        case .fetchMemberGoals(let isRefresh):
            await fetchGoalMember(isRefresh: isRefresh)
            
        case .fetchInformationMenu:
            await fetchMenuBotomHome()
        }
    }
    
    func getNameMember(member: FHKMemberEntity) -> String {
        member.memberName
    }
    
    func getAvatarMember(member: FHKMemberEntity) -> String {
        member.avatarName
    }
    
    func getId(member: FHKMemberEntity) -> UUID {
        member.id
    }
}

private extension FHKHomeScreenVM {
    
    func fetchGoalMember(isRefresh: Bool) async {
        viewState.goalMemberState = .skeleton
        do {
            guard let email = viewState.parentEmail else {
                showNotificationError(msn: viewState.errorRecoveryInfoUser)
                viewState.rewardsState = .defaultDataError
                return
            }

            let goalMember = try await fhkGoalsRepository.fetchGoalMemberFamily(email, isRefresh)
            goalMemberList = goalMember
            viewState.goalMemberState = .loaded
        } catch {
            viewState.goalMemberState = .defaultDataError
            showNotificationError(msn: viewState.msnErrorFetchGoalList)
        }
    }
    
    func fetchRewardsCollected(isRefresh: Bool) async {
        viewState.rewardsState = .skeleton
        do {
            guard let email = viewState.parentEmail else {
                showNotificationError(msn: viewState.errorRecoveryInfoUser)
                viewState.rewardsState = .defaultDataError
                return
            }

            let rewardsCollected = try await fhkHomeRepository.fetchRewardCollected(email, isRefresh)
            rewardsCollectedList = rewardsCollected
            viewState.rewardsState = .loaded
        } catch {
            viewState.rewardsState = .defaultDataError
            showNotificationError(msn: viewState.errorRewardCollect)
        }
    }
    
    func fetchMemberFamily(isRefresh: Bool) async {
        viewState.familyState = .skeleton
        
        do {
            guard let email = viewState.parentEmail else {
                showNotificationError(msn: viewState.errorRecoveryInfoUser)
                viewState.familyState = .defaultDataError
                return
            }

            let members = try await fhkHomeRepository.fetchMembers(email, isRefresh)
            familyMembersList = members
            viewState.familyState = .loaded
        } catch {
            viewState.familyState = .defaultDataError
            showNotificationError(msn: viewState.errorFetchMembers)
        }
    }
    
    func fetchMenuBotomHome() async {
        do {
            try await fhkRemoteConfig.fetchConfig()
            let menus = fhkRemoteConfig.menuHomeItems
            viewState.settingMenuOption(items: menus())
        } catch {
            return
        }
    }
    
    func showNotificationError(msn: String) {
        fhkToast.show(FHKToastInfo(
            type: .error,
            message: msn,
            hasIcon: true)
        )
    }
}
