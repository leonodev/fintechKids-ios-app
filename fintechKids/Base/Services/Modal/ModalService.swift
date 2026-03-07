//
//  ModalService.swift
//  fintechKids
//
//  Created by Fredy Leon on 2/3/26.
//

import SwiftUI
import Observation
import FHKDomain
import FHKUtils

@Observable
public final class FHKModal: FHKModalProtocol {
    public var isPresented: Bool = false
    public var content: AnyView?
    public var config: FHKPopupConfig?

    public init() {}

    public func show<V: View>(@ViewBuilder _ content: () -> V) {
        self.content = AnyView(content())
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            self.isPresented = true
        }
    }

    public func dismiss() {
        withAnimation(.easeIn(duration: 0.2)) {
            self.isPresented = false
        }
    }
}
