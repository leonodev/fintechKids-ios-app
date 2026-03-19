//
//  Routes.swift
//  fintechKids
//
//  Created by Fredy Leon on 20/12/25.
//

import SwiftUI
import FHKCore
import FHKUtils
import FHKDomain

// Define each case for a navigation route
public enum Routes: NavigationDestination {
    case language
    case login
    case register
    case home
    case members
    case memberDetail(MemberEntity)
    case goal
    case profile
    case tasks
    case createTask
    
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
        case .memberDetail: return "members_detail"
        case .goal: return "goal"
        case .profile: return "profile"
        case .tasks: return "tasks"
        case .createTask: return "create_task"
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
            return "register".localized().capitalizingFirstLetter()
            
        case .home:
            return nil
            
        case .members:
            return "title_add_member".localized().capitalizingFirstLetter()
            
        case .memberDetail:
            return nil
            
        case .goal:
            return "goal".localized().capitalizingFirstLetter()
            
        case .profile:
            return "profile".localized().capitalizingFirstLetter()
            
        case .tasks, .createTask:
            return "tasks".localized().capitalizingFirstLetter()
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
            RegisterMembersScreen(viewModel: RegisterMembersScreenVM())
            
        case .memberDetail(let memberEntity):
            MemberDetailScreen(viewModel: MemberDetailScreenVM(), member: memberEntity)
            
        case .goal:
            GoalScreen(viewModel: GoalScreenVM())
            
        case .profile:
            ProfileScreen(viewModel: ProfileScreenVM())
            
        case .tasks:
            TasksScreen(viewModel: TasksScreenVM())
            
        case .createTask:
            TaskCreateScreen(viewModel: TaskCreateScreenVM())
        }
    }
}
