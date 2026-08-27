//
//  FHKModalPresenter.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 27/8/26.
//

import SwiftUI
import FHKCore

public struct ModalPresenter: ViewModifier {
    var manager: FHKModal
    
    public init(manager: FHKModal) {
        self.manager = manager
    }

    public func body(content: Content) -> some View {
        content
            .overlay {
                if manager.isPresented(), let popupContent = manager.content() {
                    PopupContainer(content: popupContent) {
                        manager.dismiss()
                    }
                    .transition(.opacity.combined(with: .scale(scale: 0.9)))
                }
            }
    }
}
