//
//  FHKRegisterMembersRepository+Live.swift
//  fintechKids
//
//  Created by Fredy Leon on 3/3/26.
//

import FHKDomain
import FHKInjections
import FHKStorage

public extension FHKRegisterMembersRepository {
    
    static var live: Self {
        var registeMembers = Self()
        
        registeMembers.registerMembers = { members in
            try await inject.fhkSupabaseMembers.addMembers(members)
        }
        
        registeMembers.getParentMail = {
            inject.fhkConfiguration.parentMail()
        }
        
        registeMembers.getFamilyName = {
            inject.fhkConfiguration.refreshFamilyName()
            return inject.fhkConfiguration.familyName()
        }
        
        return registeMembers
    }
}
