//
//  FHKToast+Mock.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 4/9/26.
//

import SwiftUI
import FHKCore

public extension FHKToast {
    
    @MainActor
    static var preview: Self {
        var manager = Self()
        let service = FHKToastService()
        
        manager.currentToast = { @MainActor in
            FHKToastInfo(type: .success, message: "Toast Success Info", hasIcon: true)
        }
        
        manager.isVisible = { @MainActor in
            return false
        }
        
        manager.show = { info, duration in
            Task { @MainActor in service.show(info: info, duration: duration) }
        }
        
        manager.dismiss = {
            Task { @MainActor in service.dismiss() }
        }
        
        return manager
    }  
}
