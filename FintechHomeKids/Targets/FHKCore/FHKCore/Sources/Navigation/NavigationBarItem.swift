//
//  NavigationBarItem.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 26/8/26.
//

import Foundation

/// Item de la barra de navegación
public struct NavigationBarItem: Identifiable, Sendable {
    public let id = UUID()
    public let icon: String
    public let action: @Sendable @MainActor () -> Void
    public let placement: NavigationBarItemPlacement
    
    public enum NavigationBarItemPlacement: Sendable {
        case leading
        case trailing
    }
    
    public init(
        icon: String,
        placement: NavigationBarItemPlacement = .trailing,
        action: @escaping @Sendable @MainActor () -> Void
    ) {
        self.icon = icon
        self.placement = placement
        self.action = action
    }
}
