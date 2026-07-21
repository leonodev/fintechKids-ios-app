//
//  FHKModal+Live.swift
//  fintechKids
//
//  Created by Fredy Leon on 2/3/26.
//

import SwiftUI
import Observation
import FHKDomain
import FHKUtils

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
}

@Observable
@MainActor
private final class LiveModalState {
    var isPresented: Bool = false
    var content: AnyView?
    var config: FHKPopupConfig?
    private var onDismissAction: (() -> Void)?

    init() {}

    func show(onDismiss: (() -> Void)?, config: FHKPopupConfig?, view: AnyView) {
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

/*
@Observable
public final class FHKModal: FHKModalProtocol {
    public var isPresented: Bool = false
    public var content: AnyView?
    public var config: FHKPopupConfig?
    private var onDismissAction: (() -> Void)?

    public init() {}

    public func show<V: View>(onDismiss: (() -> Void)? = nil, @ViewBuilder content: () -> V) {
        self.onDismissAction = onDismiss
        self.content = AnyView(content())
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            self.isPresented = true
        }
    }

    public func dismiss() {
        onDismissAction?()
        onDismissAction = nil
        
        withAnimation(.easeIn(duration: 0.2)) {
            self.isPresented = false
        }
    }
}
*/
