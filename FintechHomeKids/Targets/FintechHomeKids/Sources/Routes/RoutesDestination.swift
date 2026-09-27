//
//  RoutesDestination.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 8/9/26.
//

import SwiftUI
import FHKCore
import FHKDomain
import FHKAuth
import FHKHome
import FHKMembers
import FHKGoals
import FHKTasks
import FHKRewards
import FHKDesignSystem

extension RoutesDestination {
    
    @MainActor
    static func registerResolver() {
        viewResolver = { destination in
            AnyView(resolveView(for: destination))
        }
    }
    
    @MainActor @ViewBuilder
    private static func resolveView(for destination: RoutesDestination) -> some View {
        switch destination {
        case .language:
            FHKLanguageScreen()
            
        case .login:
            FHKLoginScreen()
            
        case .register:
            FHKRegisterScreen()
            
        case .home:
            FHKHomeScreen()
            
        case .members:
            FHKRegisterMembersScreen()
            
        case .memberDetail(let memberID):
            FHKMemberDetailScreen(memberID)
            
        case .profile:
            FHKProfileScreen()
            
        case .listGoals:
            FHKGoalListScreen()
            
        case .createGoals:
            FHKGoalCreateScreen()
            
        case .listRewards:
            FHKRewardListScreen()
            
        case .createRewards:
            FHKRewardCreateScreen()
            
        case .collectReward(let collectEntity, let memberEntity):
            EmptyView()
            
        case .presentGoldenTicket(let payload):
            if let ticket = payload.value(as: FHKGoldenTicketEntity.self) {
                FHKRewardGoldenTicketScreen(ticketEntity: ticket)
            }
            FHKRoutingErrorView()
            
        case .startTask(let taskEntity, let memberEntity):
            if let task = taskEntity.value(as: FHKTaskEntity.self),
                let member = taskEntity.value(as: FHKMemberEntity.self) {
                FHKTaskStartScreen(task: task, member: member)
            }
            FHKRoutingErrorView()
            
        case .createTasks:
            EmptyView()
            //FHKTaskCreateScreen(viewModel: TaskCreateScreenVM())
            
        case .createMembers:
            EmptyView()
        }
    }
}
