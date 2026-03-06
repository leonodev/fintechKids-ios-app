//
//  RegisterMembersScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 1/2/26.
//

import Observation
import FHKCore
import FHKInjections
import FHKFirebase
import FHKUtils
import FHKDomain

@Observable
final class RegisterMembersScreenVM: FHKCore.ViewModel {
    var viewState: RegisterMembersViewState = .init()
    
    // Properties injected
    private var registerMembersRepository: any FHKRegisterMembersRepositoryProtocol {
        inject.registerMembersRepository
    }
    
    public var modalManager: any FHKModalProtocol {
        inject.modalManager
    }
    
    private var analitycsManager: any FHKAnalyticsProtocol {
        inject.firebaseAnalitycsManager
    }
    
    // Other Properties
    public var familyMembers: [MemberEntity] = []
    public var isEnableBtnRegisterMember: Bool {
        !viewState.familyName.isEmpty && !familyMembers.isEmpty
    }
    
    enum Action: Equatable {
        case newMember
        case clearInfomember(avatarName: String)
        case registerMembers
        case removeMember(member: MemberEntity)
    }
    
    func action(_ action: Action) async {
        switch action {
            
        case .newMember:
            await newMember()

        case .clearInfomember(let avatar):
            await clearInfoMember(avatarName: avatar)
            
        case .registerMembers:
            await registerMembers()
            
        case .removeMember(let member):
            await removeMember(member)
        }
    }
    
    @MainActor
    func newMember() async {
        guard let emailParent = await registerMembersRepository.getParentMail() else {
            viewState.addMemberState = .error(FHKSecurityError.readUserMailKeychainFailed)
            return
        }
        
       
        let newMember = MemberEntity(emailParent: emailParent,
                                     memberName: viewState.memberNewName,
                                     avatarName: viewState.selectedAvatarName)
        familyMembers.append(newMember)
    }
    
    @MainActor
    func clearInfoMember(avatarName: String) async {
        clearInfoNewMember(avatarName: avatarName)
    }
    
    @MainActor
    func registerMembers() async {
        do {
            try await registerMembersRepository.registerMembers(members: familyMembers)
            viewState.addMemberState = .finish(nil)
        } catch {
            viewState.addMemberState = .error(FHKAppError.addMembersFailed)
            informateError(FHKAppError.addMembersFailed)
        }
    }
    
    @MainActor
    func removeMember(_ member: MemberEntity) async {
        familyMembers.removeAll(where: { $0.id == member.id })
    }
    
    func getNameMember(member: MemberEntity) -> String {
        member.memberName
    }
    
    func getAvatarMember(member: MemberEntity) -> String {
        member.avatarName
    }
    
    func getIconName(member: MemberEntity) -> String {
        member.iconName
    }
    
    func clearInfoNewMember(avatarName: String) {
        viewState.selectedAvatarName = avatarName
        viewState.memberNewName = ""
    }
}

private extension RegisterMembersScreenVM {
    
    func informateError(_ error: any FHKError) {
        if error.isShouldTrack {
            analitycsManager.track(.error(.init(from: error)))
        }
        
        viewState.titleUserError = error.titleUI
        viewState.msnUserError = error.messageUI
        Logger.error(error.logMessage)
    }
}
