//
//  View+Extension.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 19/4/26.
//

import SwiftUI
import FHKCore

public extension View {
    @ViewBuilder
    func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        transform: (Self) -> TrueContent,
        else elseTransform: (Self) -> FalseContent
    ) -> some View {
        if condition {
            transform(self)
        } else {
            elseTransform(self)
        }
    }
}

public extension View {
    func setToastStyle(isVisible: Binding<Bool>, info: FHKToastInfo) -> some View {
        modifier(ToastModifier(isVisible: isVisible, info: info))
    }
}
