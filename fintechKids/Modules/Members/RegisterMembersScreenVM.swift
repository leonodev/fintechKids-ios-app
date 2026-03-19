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
    private var fhkRegisterMembersRepository: any FHKRegisterMembersRepositoryProtocol {
        inject.fhkRegisterMembersRepository
    }
    
    public var fhkModal: any FHKModalProtocol {
        inject.fhkModal
    }
    
    private var fhkFirebaseAnalitycs: any FHKAnalyticsProtocol {
        inject.fhkFirebaseAnalitycs
    }
    
    // Other Properties
    public var familyMembers: [MemberEntity] = []
    public var isEnableBtnRegisterMember: Bool {
        !familyMembers.isEmpty
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
        guard let emailParent = await fhkRegisterMembersRepository.getParentMail() else {
            viewState.registerMembersState = .finish(result: .error)
            return
        }
        
        guard let familyName = await fhkRegisterMembersRepository.getFamilyName() else {
            viewState.registerMembersState = .finish(result: .error)
            return
        }
           
        let newMember = MemberEntity(emailParent: emailParent,
                                     memberName: viewState.memberNewName,
                                     familyName: familyName,
                                     avatarName: viewState.selectedAvatarName
        )
        familyMembers.append(newMember)
    }
    
    @MainActor
    func clearInfoMember(avatarName: String) async {
        clearInfoNewMember(avatarName: avatarName)
    }
    
    @MainActor
    func registerMembers() async {
        viewState.registerMembersState = .loading
        
        do {
            try await fhkRegisterMembersRepository.registerMembers(members: familyMembers)
            viewState.registerMembersState = .finish(result: .success)
        } catch let error as FHKSupabaseError {
            viewState.registerMembersState = .finish(result: .error)
            informateError(error)
        } catch {
            informateError(FHKMembersError.addMembersFailed)
            viewState.registerMembersState = .finish(result: .error)
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
            fhkFirebaseAnalitycs.track(.error(.init(from: error)))
        }
        
        viewState.msnUserError = error.messageLocalized
        Logger.error(error.logMessage)
    }
}
