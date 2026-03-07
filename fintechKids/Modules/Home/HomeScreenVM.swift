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
    private var fhkHomeRepository: FHKHomeRepositoryProtocol {
        inject.fhkHomeRepository
    }
    
    public var fhkToast: any FHKToastProtocol {
        inject.fhkToast
    }
    
    public var fhkCameraPermission: any FHKPermissionProtocol {
        inject.fhkCameraPermission
    }
    
    // Other Properties
    public var familyMembers: [MemberEntity] = []
    
    public var parentMail: String? {
        fhkHomeRepository.getParentMail()
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
            guard let email = parentMail else {
                showNotificationError(msn: viewState.errorRecoveryInfoUser)
                return
            }

            let currentMember = try await fhkHomeRepository.fetchMembers(email: email)
            familyMembers = currentMember
        } catch {
            showNotificationError(msn: viewState.errorFetchMembers)
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
