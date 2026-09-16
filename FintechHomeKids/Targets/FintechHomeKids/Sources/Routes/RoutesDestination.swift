//
//  RoutesDestination.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 8/9/26.
//

import SwiftUI
import FHKCore
import FHKAuth
import FHKHome
import FHKMembers

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
            EmptyView()
            
        case .memberDetail(let memberID):
            FHKMemberDetailScreen(memberID)
            
        case .profile:
            FHKProfileScreen()
            
        case .createMembers, .createRewards, .createGoals, .createTasks:
            EmptyView()
        }
    }
}
