//
//  FHKToastService.swift
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
public final class FHKToastService: NSObject, ApplicationService {
    public var currentToast: FHKToastInfo?
    public var isVisible: Bool = false
    private var dismissalTask: Task<Void, Never>?

    public func show(info: FHKToastInfo, duration: Double) {
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
    
    public func dismiss() {
        dismissalTask?.cancel()
        dismissalTask = nil
        
        withAnimation(.snappy) {
            self.isVisible = false
        }
    }
}

extension FHKToast {
    public func show(_ info: FHKToastInfo, duration: Double = 5.0) {
        self.show(info, duration)
    }
}
