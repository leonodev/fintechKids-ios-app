//
//  RoutesDestination.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 8/9/26.
//

import Foundation
import SwiftUI

public enum RoutesDestination: NavigationDestination {
    case language
    case login
    case register
    case home
    case createMembers
    case createRewards
    case createGoals
    case createTasks
    case profile
    case members
    case memberDetail(UUID)
    
    public typealias ContentView = AnyView
    
    @MainActor
    public static var viewResolver: ((RoutesDestination) -> AnyView)?
    
    // Título o configuración por defecto si aplica
    public var hidesNavigationBar: Bool {
        switch self {
        case .login, .language, .home: return true
        default: return false
        }
    }
    
    @MainActor
    public func view() -> AnyView {
        if let resolver = Self.viewResolver {
            return resolver(self)
        }
        
        return AnyView(
            VStack(spacing: 12) {
                Image(systemName: "rectangle.portrait.and.arrow.forward")
                    .font(.largeTitle)
                Text("Preview Destination: \(String(describing: self))")
                    .font(.headline)
            }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGroupedBackground))
        )
    }
}
