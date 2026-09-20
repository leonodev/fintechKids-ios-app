//
//  FHKRegisterMembersRepository+Live.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 17/9/26.
//

import Foundation
import FHKDomain
import FHKCore
import FLibInjections
import Supabase

public extension FHKRegisterMembersRepository {
    
    static func live(supabaseClient: SupabaseClient) -> Self {
        var repository = Self()
        let supabaseMembers = FHKSupabaseMembers(supabaseClient: supabaseClient)
        let config = inject.fhkConfiguration
        
        repository.registerMembers = { members in
            try await supabaseMembers.addMembers(members: members)
        }
        
        repository.getParentMail = {
            config.parentMail()
        }
        
        repository.getFamilyName = {
            config.familyName()
        }
        
        return repository
    }
}
