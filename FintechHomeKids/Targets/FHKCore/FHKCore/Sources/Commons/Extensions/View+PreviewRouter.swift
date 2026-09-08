//
//  View+PreviewRouter.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 8/9/26.
//
import SwiftUI

public extension View {
    /// Inyecta un NavigationRouter<RoutesDestination> por defecto para Previews
    func withPreviewRouter() -> some View {
        self.environment(NavigationRouter<RoutesDestination>())
    }
}
