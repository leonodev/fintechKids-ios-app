//
//  HomeScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 21/1/26.
//

import Observation
import FHKCore
import FHKInjections
import FHKDomain

@Observable
final class HomeScreenVM: FHKCore.ViewModel {
    var model: HomeModel = .init()
    
    // Properties Injection
    private var supabaseMembers: FHKSupabaseMembersProtocol {
        inject.supabaseMembersManager
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
            guard let email = await model.getParentMail() else {
                model.homeState = .error(FHKSecurityError.readUserMailKeychainFailed)
                return
            }

            let currentMember = try await supabaseMembers.fetchFamilyMembers(parentEmail: email)
            model.familyMembers = currentMember
        } catch {
            model.homeState = .error(FHKAppError.fetchMembersFailed)
        }
    }
}
