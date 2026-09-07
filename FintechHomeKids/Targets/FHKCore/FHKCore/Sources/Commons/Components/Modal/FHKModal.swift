//
//  FHKModal.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 27/8/26.
//

import SwiftUI
import FLibUtils
import FLibInjections

@MainActor
public struct FHKModal: Sendable {
    public var isPresented: @MainActor @Sendable () -> Bool = { false }
    public var content: @MainActor @Sendable () -> AnyView? = { nil }
    public var config: @MainActor @Sendable () -> PopupConfig? = { nil }
    public var showContent: @MainActor @Sendable ((@MainActor @Sendable () -> Void)?, AnyView, PopupConfig?) -> Void = { _, _, _ in }
    public var dismiss: @MainActor @Sendable () -> Void = {}
    
    public init() {}
    
    public func show<V: View>(
        config: PopupConfig? = nil,
        onDismiss: (@MainActor @Sendable () -> Void)? = nil,
        @ViewBuilder content: () -> V
    ) {
        let erasedView = AnyView(content())
        self.showContent(onDismiss, erasedView, config)
    }
}

@MainActor
public extension DependenciesInjection {
    
    var fhkModal: FHKModal {
        get { inject.get(FHKModal.self, live: .live, preview: .preview, testing: .test) }
        set { inject.set(newValue, for: FHKModal.self) }
    }
}

#if DEBUG
extension FHKModal {
    
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
#endif
