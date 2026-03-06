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
    public var familyMembers: [MemberEntity] = []
    
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
