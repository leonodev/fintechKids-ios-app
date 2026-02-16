//
//  Routes.swift
//  fintechKids
//
//  Created by Fredy Leon on 20/12/25.
//

import SwiftUI
import FHKCore
import FHKUtils

// Define each case for a navigation route
public enum Routes: NavigationDestination {
    case language
    case login
    case register
    case home
    case members
    case goal(id: String)
    
    public var hidesNavigationBar: Bool {
        switch self {
        case .language, .login, .home:
            return true
        default:
            return false
        }
    }
    
    public var id: String {
        switch self {
        case .language: return "language"
        case .login: return "login"
        case .register: return "register"
        case .home: return "home"
        case .members: return "members"
        case .goal(let id): return "goal_\(id)"
        }
    }
}

// Define each title by navigation bar
extension Routes {
    
    public var title: String? {
        switch self {
            
        case .language:
            return "language".localized().capitalizingFirstLetter()
            
        case .login:
            return nil
            
        case .register:
            return ""
            
        case .home:
            return nil
            
        case .members:
            return nil
            
        case .goal:
            return "goal".localized().capitalizingFirstLetter()
        }
    }
}

// Define the respective view for each navigation
extension Routes {
    
    @MainActor @ViewBuilder
    public func view() -> some View {
        switch self {

        case .language:
            LanguageScreen(viewModel: LanguageScreenVM())
            
        case .login:
            LoginScreen(viewModel: LoginScreenVM())
            
        case .register:
            RegisterScreen(viewModel: RegisterScreenVM())
            
        case .home:
            HomeScreen(viewModel: HomeScreenVM())
            
        case .members:
            AddMemberScreen(viewModel: AddMemberScreenVM())
            
        case .goal(let id):
            GoalScreen(id: id)
        }
    }
}
