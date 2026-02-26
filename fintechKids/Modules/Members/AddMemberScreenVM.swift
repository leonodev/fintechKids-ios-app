//
//  AddMemberScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 1/2/26.
//

import Observation
import Supabase
import FHKCore
import FHKInjections
import FHKDomain

@Observable
final class AddMemberScreenVM: FHKCore.ViewModel {
    var model: AddMemberModel = .init()
    
    // Properties injected
    private var supabaseTableMembers: any FHKSupabaseMembersProtocol {
        inject.supabaseTableMembersManager
    }
    
    enum Action: Equatable {
        case newMember
        case clearInfomember
        case registerMembers
        case removeMember(member: FamilyMember)
    }
    
    func action(_ action: Action) async {
        switch action {
            
        case .newMember:
            await newMember()

        case .clearInfomember:
            await clearInfomember()
            
        case .registerMembers:
            await registerMembers()
            
        case .removeMember(let member):
            await removeMember(member)
        }
    }
    
    @MainActor
    func newMember() async {
        guard let emailParent = await model.getParentMail() else {
            model.addMemberState = .error(FHKSecurityError.readUserMailKeychainFailed)
            return
        }
        
        let newMember = FamilyMember(email: emailParent,
                                     memberName: model.memberNewName,
                                     avatarImage: model.selectedAvatarName)
        
        model.familyMembers.append(newMember)
    }
    
    @MainActor
    func clearInfomember() async {
        model.clearInfoNewmember()
    }
    
    @MainActor
    func registerMembers() async {
        do {
            try await supabaseTableMembers.addMembers(members: model.familyMembers)
            model.addMemberState = .finish(nil)
        } catch {
            model.addMemberState = .error(FHKAppError.addMembersFailed)
        }
    }
    
    @MainActor
    func removeMember(_ member: FamilyMember) async {
        model.familyMembers.removeAll(where: { $0.id == member.id })
    }
}
