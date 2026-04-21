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
    case goals
    case createGoal
    case tasks(isFromChildSelection: Bool, MemberEntity?)
    case createTask
    case startTask(TaskEntity, MemberEntity)
    case collectReward(CollectRewardModel, MemberEntity)
    case profile
    case presentGoldenTicket(GoldenTicketEntity)
    
    public var hidesNavigationBar: Bool {
        switch self {
        case .language, .login, .home, .presentGoldenTicket:
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
        case .createGoal: return "goalCreate"
        case .goals: return "goals"
        case .profile: return "profile"
        case .tasks: return "tasks"
        case .createTask: return "create_task"
        case .startTask: return "start_task"
        case .collectReward: return "collect_reward"
        case .presentGoldenTicket: return "golden_ticket"
        }
    }
}

// Define each title by navigation bar
extension Routes {
    
    public struct Titles {
        public static let language = "language".localized().capitalizingFirstLetter()
        public static let login = "login".localized().capitalizingFirstLetter()
        public static let register = "register".localized().capitalizingFirstLetter()
        public static let home = "home".localized().capitalizingFirstLetter()
        public static let members = "title_add_member".localized().capitalizingFirstLetter()
        public static let createGoal = "goal".localized().capitalizingFirstLetter()
        public static let goals = "goal_list".localized().capitalizingFirstLetter()
        public static let profile = "profile".localized().capitalizingFirstLetter()
        public static let tasks = "tasks".localized().capitalizingFirstLetter()
        public static let collectReward = "collect_reward".localized().capitalizingFirstLetter()
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
            
        case .createGoal:
            GoalScreen(viewModel: GoalScreenVM())
            
        case .goals:
            GoalListScreen(viewModel: GoalListScreenVM())
            
        case .profile:
            ProfileScreen(viewModel: ProfileScreenVM())
            
        case .tasks(let isFromChildSelection, let member):
            TasksScreen(viewModel: TasksScreenVM(),
                        member: member,
                        isFromChildSelection: isFromChildSelection)
        case .createTask:
            TaskCreateScreen(viewModel: TaskCreateScreenVM())
            
        case .startTask(let task, let member):
            TaskStartScreen(viewModel: TaskStartScreenVM(), task: task, member: member)
            
        case .collectReward(let collectRewardModel, let member):
            RewardCollectScreen(viewModel: RewardCollectScreenVM(),
                                collectModel: collectRewardModel,
                                member: member)
            
        case .presentGoldenTicket(let info):
            RewardGoldenTicketScreen(ticketEntity: info)
        }
    }
}
