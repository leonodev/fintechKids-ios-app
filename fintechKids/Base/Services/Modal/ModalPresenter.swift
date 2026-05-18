//
//  ModalPresenter.swift
//  fintechKids
//
//  Created by Fredy Leon on 2/3/26.
//

import SwiftUI
import FHKDomain

public struct FHKModalPresenter: ViewModifier {
    var manager: FHKModalProtocol
    
    public init(manager: FHKModalProtocol) {
        self.manager = manager
    }

    public func body(content: Content) -> some View {
        content
            .overlay {
                if manager.isPresented, let popupContent = manager.content {
                    FHKPopupContainer(content: popupContent) {
                        manager.dismiss()
                    }
                    .transition(.opacity.combined(with: .scale(scale: 0.9)))
                }
            }
    }
}
