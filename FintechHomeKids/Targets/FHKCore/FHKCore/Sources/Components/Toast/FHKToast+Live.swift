//
//  FHKToast+Live.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 28/8/26.
//

import SwiftUI

public extension FHKToast {
    
    @MainActor
    static var live: Self {
        var manager = Self()
        let service = FHKToastService()
        manager.currentToast = { @MainActor in service.currentToast }
        manager.isVisible    = { @MainActor in service.isVisible }
        
        manager.show = { info, duration in
            Task { @MainActor in service.show(info: info, duration: duration) }
        }
        
        manager.dismiss = {
            Task { @MainActor in service.dismiss() }
        }
        
        return manager
    }
}
