//
//  ToastService.swift
//  fintechKids
//
//  Created by Fredy Leon on 18/1/26.
//

import SwiftUI
import Combine
import FHKCore
import FHKDesignSystem
import FHKDomain
import FHKUtils

@MainActor
@Observable
final class ToastService: NSObject, ApplicationService, FHKToastProtocol {
    var currentToast: FHKToastInfo?
    var isVisible: Bool = false
    private var dismissalTask: Task<Void, Never>?

    /// Displays a slice of toast with a specific setting and duration.
    func show(info: FHKToastInfo, duration: Double = 5.0) {
        dismissalTask?.cancel()

        self.currentToast = info
        withAnimation(.snappy) {
            self.isVisible = true
        }
        
        dismissalTask = Task {
            try? await Task.sleep(for: .seconds(duration))
            
            if !Task.isCancelled {
                self.dismiss()
            }
        }
    }
    
    /// Oculta el toast inmediatamente
    func dismiss() {
        dismissalTask?.cancel()
        dismissalTask = nil
        
        withAnimation(.snappy) {
            self.isVisible = false
        }
    }
}

public extension FHKToastProtocol {
    func show(info: FHKToastInfo, duration: Double = 5.0) {
        self.show(info: info, duration: duration)
    }
}
