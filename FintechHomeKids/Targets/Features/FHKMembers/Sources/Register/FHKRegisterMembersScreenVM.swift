//
//  FHKRegisterMembersScreenVM.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 17/9/26.
//

import Foundation
import Observation
import FHKCore
import FLibInjections
import FHKDomain
import FLibUtils

@Observable
final class FHKRegisterMembersScreenVM: FHKCore.ViewModel {
    var viewState: FHKRegisterMembersViewState = .init()
    
    private var fhkRepository: FHKRegisterMembersRepository {
        inject.fhkRegisterMembersRepository
    }
    
    public var fhkModal: FHKModal {
        inject.fhkModal
    }
    
    private var fhkAnalitycs: FHKAnalytics {
        inject.fhkAnalitycs
    }
    
    // Other Properties
    public var familyMembers: [FHKMemberEntity] = []
    public var isEnableBtnRegisterMember: Bool {
        !familyMembers.isEmpty
    }
    
    public enum Action: Equatable {
        case newMember
        case clearInfomember(avatarName: String)
        case registerMembers
        case removeMember(member: FHKMemberEntity)
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
        do {
            async let emailTask = fhkRepository.getParentMail()
            async let familyTask = fhkRepository.getFamilyName()
            
            let (emailParent, familyName) = try await (emailTask, familyTask)
            
            if let email = emailParent, !email.isEmpty,
               let family = familyName, !family.isEmpty {
                preparateNewMember(emailParent: email, familyName: family)
            }
        } catch {
            viewState.registerMembersState = .finish(result: .error)
            informateError(FHKMembersError.getInfoFamilyFailed)
        }
    }
    
    
    func preparateNewMember(emailParent: String, familyName: String) {
        let newMember = FHKMemberEntity(emailParent: emailParent,
                                     memberName: viewState.memberNewName,
                                     familyName: familyName,
                                     avatarName: viewState.selectedAvatarName)
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
            try await fhkRepository.registerMembers(familyMembers)
            viewState.registerMembersState = .finish(result: .success)
//        } catch let error as FHKSupabaseError {
//            viewState.registerMembersState = .finish(result: .error)
//            informateError(error)
        } catch {
            informateError(FHKMembersError.addMembersFailed)
            viewState.registerMembersState = .finish(result: .error)
        }
    }
    
    @MainActor
    func removeMember(_ member: FHKMemberEntity) async {
        familyMembers.removeAll(where: { $0.id == member.id })
    }
    
    func getNameMember(member: FHKMemberEntity) -> String {
        member.memberName
    }
    
    func getAvatarMember(member: FHKMemberEntity) -> String {
        member.avatarName
    }
    
    func getIconName(member: FHKMemberEntity) -> String {
        member.iconName
    }
    
    func clearInfoNewMember(avatarName: String) {
        viewState.selectedAvatarName = avatarName
        viewState.memberNewName = ""
    }
}

private extension FHKRegisterMembersScreenVM {
    
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
