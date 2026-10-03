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
    case listRewards
    case createRewards
    case collectReward(collectEntity: AnyHashableSendable, memberEntity: AnyHashableSendable)
    case listGoals
    case tasks(member: AnyHashableSendable? = nil, isFromChildSelection: Bool = false)
    case startTask(taskEntity: AnyHashableSendable, memberEntity: AnyHashableSendable)
    case createGoals
    case createTasks
    case profile
    case members
    case memberDetail(UUID)
    case presentGoldenTicket(payload: AnyHashableSendable)
    
    public typealias ContentView = AnyView
    
    @MainActor
    public static var viewResolver: ((RoutesDestination) -> AnyView)?
    
    // Título o configuración por defecto si aplica
    public var hidesNavigationBar: Bool {
        switch self {
        case .login, .language, .home, .presentGoldenTicket: return true
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
    
    public var namedDeepLinkable: String {
        switch self {
        case .language: return "language"
        case .login: return "login"
        case .register: return "register"
        case .home: return "home"
        case .createMembers: return "createMembers"
        case .listRewards: return "listRewards"
        case .createRewards: return "createRewards"
        case .collectReward: return "collectReward"
        case .listGoals: return "listGoals"
        case .tasks: return "tasks"
        case .startTask: return "startTask"
        case .createGoals: return "createGoals"
        case .createTasks: return "createTasks"
        case .profile: return "profile"
        case .members: return "members"
        case .memberDetail: return "memberDetail"
        case .presentGoldenTicket: return "presentGoldenTicket"
        }
    }
}
