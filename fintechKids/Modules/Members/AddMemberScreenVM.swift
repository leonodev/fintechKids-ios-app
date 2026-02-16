//
//  AddMemberScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 1/2/26.
//

import SwiftUI
import Combine
import Supabase
import FHKCore
import FHKAuth
import FHKStorage
import FHKUtils
import Observation

@Observable
final class AddMemberScreenVM: FHKCore.ViewModel {
    var model: AddMemberModel = .init()
    
    enum Action: Equatable {
        case onAppear
        case clearInfomember
        case addNewMember
        case removeMember(member: FamilyMember)
    }
    
    func action(_ action: Action) async {
        switch action {
        case .onAppear:
            break
            
        case .clearInfomember:
            clearInfomember()
            
        case .addNewMember:
            await addNewMember()
            
        case .removeMember(let member):
            await removeMember(member)
        }
    }
    
    func removeMember(_ member: FamilyMember) async {
        model.familyMembers.removeAll(where: { $0.id == member.id })
    }
    
    func clearInfomember() {
        model.clearInfoNewmember()
    }
    
    @MainActor
    func addNewMember() async {
        let client: SupabaseClient? = SupabaseAuth.getSecureSupabaseClient()
        
        guard let clientSupabase = client else {
            return
        }
        
        let FamilyMember = SupabaseFamilyMembers(supabaseClient: clientSupabase)
        
        do {
            try await FamilyMember.addMember(name: "pepito", email: model.emailFamily)
            
            Logger.info("pepito addes success")
        } catch {
            Logger.error(error.localizedDescription)
        }
    }
}
