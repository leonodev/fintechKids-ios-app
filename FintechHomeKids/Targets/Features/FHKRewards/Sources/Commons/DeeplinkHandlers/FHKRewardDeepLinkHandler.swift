//
//  FHKRewardDeepLinkHandler.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 1/10/26.
//

import Foundation
import FHKCore
import FLibUtils

@MainActor
public struct FHKRewardDeepLinkHandler: DeepLinkHandler {
    private let router: NavigationRouter<RoutesDestination>

    public init(router: NavigationRouter<RoutesDestination>) {
        self.router = router
    }

    public func canHandle(url: URL) -> Bool {
        guard url.scheme == "fhkApp", let host = url.host else { return false }
        // 💡 Hosts supported by this feature
        return [RoutesDestination.listRewards.namedDeepLinkable].contains(host)
    }

    public func handle(url: URL) {
        Logger.info("🎯 [FHKRewardDeepLinkHandler] Trying to drive URL: \(url)")
        
        guard canHandle(url: url) else {
            Logger.error("❌ [FHKRewardDeepLinkHandler] 'canHandle' return FALSE for: \(url)")
            return
        }
        
        guard let host = url.host else { return }

        switch host {
        case RoutesDestination.listRewards.namedDeepLinkable:
            router.navigate(to: .listRewards)

        default:
            Logger.warning("⚠️ [FHKRewardDeepLinkHandler] Host unknown: \(host)")
        }
    }
}
