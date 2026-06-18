//
//  ModalMock.swift
//  fintechKids
//
//  Created by fleon  on 11/6/26.
//

import FHKDomain
import SwiftUI

public final class ModalMock: @unchecked Sendable, FHKModalProtocol {
    public var isPresented: Bool = false
    public var content: AnyView?
    
    public func show<V: View>(onDismiss: (() -> Void)?, @ViewBuilder content: () -> V) {
        isPresented = true
    }
    
    public func dismiss() {
        isPresented = false
    }
}
