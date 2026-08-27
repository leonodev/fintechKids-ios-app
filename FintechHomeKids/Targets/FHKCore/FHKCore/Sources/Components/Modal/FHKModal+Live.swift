//
//  FHKModal+Live.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 27/8/26.
//

import SwiftUI
import Observation
import FLibUtils

@MainActor
public extension FHKModal {
    
    /// Real version
    static var live: Self {
        let state = LiveModalState()
        var modal = Self()
        
        modal.isPresented = { state.isPresented }
        modal.content = { state.content }
        modal.config = { state.config }
        
        modal.showContent = { onDismiss, view, config in
            state.show(onDismiss: onDismiss, config: config, view: view)
        }
        
        modal.dismiss = {
            state.dismiss()
        }
        
        return modal
    }
    
    /// Version by Tests
    static var test: Self {
        Self()
    }
    
    /// Version by Previews of SwiftUI
    static var preview: Self {
        var modal = Self()
        modal.isPresented = { true }
        modal.content = { AnyView(Text("Modal Test")) }
        return modal
    }
}

@Observable
@MainActor
private final class LiveModalState {
    var isPresented: Bool = false
    var content: AnyView?
    var config: PopupConfig?
    private var onDismissAction: (() -> Void)?

    init() {}

    func show(onDismiss: (() -> Void)?, config: PopupConfig?, view: AnyView) {
        self.onDismissAction = onDismiss
        self.config = config
        self.content = view
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            self.isPresented = true
        }
    }

    func dismiss() {
        onDismissAction?()
        onDismissAction = nil
        
        withAnimation(.easeIn(duration: 0.2)) {
            self.isPresented = false
        }
    }
}
