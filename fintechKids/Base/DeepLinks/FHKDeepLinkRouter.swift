//
//  FHKDeepLinkRouter.swift
//  fintechKids
//
//  Created by Fredy Leon on 29/12/25.
//

import Foundation
import SwiftUI
import Combine
import FHKCore

@MainActor
protocol FHKDeepLinkRouterProtocol {
    func setAppRouter(_ router: NavigationRouter<FHKRoutes>)
    func handle(url: URL)
}

@MainActor
final class FHKDeepLinkRouter: FHKDeepLinkRouterProtocol {
    private var appRouter: NavigationRouter<FHKRoutes>?
    
    func setAppRouter(_ router: NavigationRouter<FHKRoutes>) {
        self.appRouter = router
    }
    
    func handle(url: URL) {
        print("🚀 Procesando Deep Link: \(url.absoluteString)")
        guard url.scheme == "fhkApp" else { return }
        
        // Example parsing: fhkApp://createGoal/123
        // xcrun simctl openurl booted fhkApp://createGoal/123
        if url.host == "createGoal" {
            // let id = url.lastPathComponent
            appRouter?.navigate(to: .createGoal)
            // appRouter?.navigate(to: .goal(id: id))
        }
    }
}
