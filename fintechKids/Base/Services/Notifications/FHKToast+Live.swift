//
//  FHKToast+Live.swift
//  fintechKids
//
//  Created by fleon  on 8/7/26.
//

import SwiftUI
import FHKCore
import FHKDesignSystem
import FHKDomain
import FHKUtils

extension FHKToast {
    
    @MainActor
    public static var live: Self {
        var manager = Self()
        let service = ToastService()
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
