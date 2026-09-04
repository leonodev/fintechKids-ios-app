//
//  FHKSecurity+Mock.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 31/8/26.
//

import FHKCore

public extension FHKSecurity {
    static var test: Self {
        Self()
    }
    
    static var preview: Self {
        var preview = Self()
        
        return preview
    }
}
