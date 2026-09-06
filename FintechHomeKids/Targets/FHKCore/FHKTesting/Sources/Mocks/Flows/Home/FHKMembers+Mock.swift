//
//  FHKMembers+Mock.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import FHKDomain

public extension FHKMembers {
    
    static var test: Self {
        Self()
    }
    
    static var preview: Self {
        var supabase = Self()
        
        supabase.fetchFamilyMembers = { email in
            [FHKMemberEntity.previewItem]
        }
        
        return supabase
    }
}
