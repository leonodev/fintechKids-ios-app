//
//  AuthDeepLinkHandler.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 26/8/26.
//

import Foundation
import FHKCore

public struct AuthDeepLinkHandler: DeepLinkHandler {
    private let router: NavigationRouter<AuthRoute>
    
    public init(router: NavigationRouter<AuthRoute>) {
        self.router = router
    }
    
    public func canHandle(url: URL) -> Bool {
        return url.scheme == "fhkApp" && url.host == "auth"
    }
    
    public func handle(url: URL) {
        if url.path == "/login" {
            router.navigate(to: .login)
        }
    }
}
