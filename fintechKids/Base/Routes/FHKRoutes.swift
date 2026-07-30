//
//  FHKRoutes.swift
//  fintechKids
//
//  Created by Fredy Leon on 20/12/25.
//

import SwiftUI
import FHKCore
import FHKUtils
import FHKDomain

// Define each case for a navigation route
public enum FHKRoutes: NavigationDestination {
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
    case rewards
    case collectReward(CollectRewardEntity, MemberEntity)
    case createReward
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
        case .rewards: return "rewards"
        case .collectReward: return "collect_reward"
        case .createReward: return "create_reward"
        case .presentGoldenTicket: return "golden_ticket"
        }
    }
}

// Define each title by navigation bar
extension FHKRoutes {
    
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
        public static let rewards = "title_rewards".localized().capitalizingFirstLetter()
        public static let collectReward = "collect_reward".localized().capitalizingFirstLetter()
        public static let createReward = "create_reward".localized().capitalizingFirstLetter()
    }
}

// Define the respective view for each navigation
extension FHKRoutes {
    
    @MainActor @ViewBuilder
    public func view() -> some View {
        switch self {

        case .language:
            FHKLanguageScreen(viewModel: FHKLanguageScreenVM())
            
        case .login:
            FHKLoginScreen(viewModel: FHKLoginScreenVM())
            
        case .register:
            FHKRegisterScreen(viewModel: FHKRegisterScreenVM())
            
        case .home:
            FHKHomeScreen(viewModel: FHKHomeScreenVM())
            
        case .members:
            FHKRegisterMembersScreen(viewModel: FHKRegisterMembersScreenVM())
            
        case .memberDetail(let memberEntity):
            FHKMemberDetailScreen(viewModel: FHKMemberDetailScreenVM(), member: memberEntity)
            
        case .createGoal:
            FHKGoalScreen(viewModel: FHKGoalScreenVM())
            
        case .goals:
            FHKGoalListScreen(viewModel: FHKGoalListScreenVM())
            
        case .profile:
            FHKProfileScreen(viewModel: FHKProfileScreenVM())
            
        case .tasks(let isFromChildSelection, let member):
            FHKTasksScreen(viewModel: FHKTasksScreenVM(),
                        member: member,
                        isFromChildSelection: isFromChildSelection)
        case .createTask:
            FHKTaskCreateScreen(viewModel: FHKTaskCreateScreenVM())
            
        case .startTask(let task, let member):
            FHKTaskStartScreen(viewModel: FHKTaskStartScreenVM(), task: task, member: member)
            
        case .collectReward(let collectRewardEntity, let memberEntity):
            FHKRewardCollectScreen(viewModel: FHKRewardCollectScreenVM(),
                                collectEntity: collectRewardEntity,
                                memberEntity: memberEntity)
            
        case .rewards:
            FHKRewardListScreen(viewModel: FHKRewardListScreenVM())
            
        case .createReward:
            FHKRewardCreateScreen(viewModel: FHKRewardCreateScreenVM())
            
        case .presentGoldenTicket(let info):
            FHKRewardGoldenTicketScreen(ticketEntity: info)
        }
    }
}
