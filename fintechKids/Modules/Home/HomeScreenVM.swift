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
    private var homeRepository: FHKHomeRepositoryProtocol {
        inject.homeRepository
    }
    
    public var toastManager: any FHKToastProtocol {
        inject.toastManager
    }
    
    public var camaraPermissionManager: any FHKPermissionProtocol {
        inject.camaraPermissionManager
    }
    
    // Other Properties
    public var familyMembers: [FamilyMember] = []
    
    public func getNameMember(member: FamilyMember) -> String {
        member.member_name
    }
    
    public func getAvatarMember(member: FamilyMember) -> String {
        member.avatar_name
    }
    
    public func getId(member: FamilyMember) -> UUID {
        member.id
    }
    
    public func getStateItemMemberComponent(member: FamilyMember) -> ComponentState {
        let isInfoComplete = !member.member_name.isEmpty && !member.avatar_name.isEmpty
        return isInfoComplete ? .loaded : .error
    }
    
    enum Action: Equatable {
        case fetchMemberFamily
    }
    
    @MainActor
    func action(_ action: Action) async {
        switch action {
        case .fetchMemberFamily:
            await fetchMemberFamily()
        }
    }
    
    func fetchMemberFamily() async {
        do {
            guard let email = await homeRepository.getParentMail() else {
                viewState.homeState = .error(FHKSecurityError.readUserMailKeychainFailed)
                return
            }

            let currentMember = try await homeRepository.fetchMembers(email: email)
            familyMembers = currentMember
            viewState.homeState = .finish(nil)
        } catch {
            viewState.homeState = .error(FHKAppError.fetchMembersFailed)
        }
    }
}
