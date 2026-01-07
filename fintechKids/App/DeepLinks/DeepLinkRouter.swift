//
//  DeepLinkRouter.swift
//  fintechKids
//
//  Created by Fredy Leon on 29/12/25.
//

import Foundation
import SwiftUI
import Combine
import FHKCore

@MainActor
protocol DeepLinkRouterProtocol {
    func setAppRouter(_ router: NavigationRouter<Routes>)
    func handle(url: URL)
}

@MainActor
final class DeepLinkRouter: DeepLinkRouterProtocol {
    private var appRouter: NavigationRouter<Routes>?
    
    func setAppRouter(_ router: NavigationRouter<Routes>) {
        self.appRouter = router
    }
    
    func handle(url: URL) {
        print("🚀 Procesando Deep Link: \(url.absoluteString)")
        guard url.scheme == "fhkApp" else { return }
        
        // Example parsing: fhkApp://goal/123
        // xcrun simctl openurl booted fhkApp://goal/123
        if url.host == "goal" {
            let id = url.lastPathComponent
            appRouter?.navigate(to: .goal(id: id))
        }
    }
}
