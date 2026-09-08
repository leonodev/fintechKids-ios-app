//
//  RoutesDestination.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 8/9/26.
//

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
    
    public typealias ContentView = AnyView
    
    @MainActor
    public static var viewResolver: ((RoutesDestination) -> AnyView)?
    
    @MainActor
    public var title: String {
        switch self {
        case .language:
            return "language"
            
        case .login:
            return "login"
            
        case .register:
            return "register"
            
        case .home:
            return "home"
            
        case .createMembers:
            return "title_new_member"
            
        case .createRewards:
            return "title_new_rewards"
            
        case .createGoals:
            return "title_new_goal"
            
        case .createTasks:
            return "title_new_tasks"
            
        case .profile:
            return "home"

        }
    }
    
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
