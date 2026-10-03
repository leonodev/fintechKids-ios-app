//
//  FHKUserNotificationHandler.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 1/10/26.
//

import UIKit
import Foundation
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import FHKCore
import FLibUtils

final class FHKUserNotificationHandler: NSObject, UNUserNotificationCenterDelegate, Sendable {
    
    @MainActor
    private var pendingDeepLink: URL?
    
    @MainActor
    var onDeepLinkReceived: ((URL) -> Void)? {
        didSet {
            // Caso Cold Launch: si la push llegó antes de configurar 'updateRouter',
            if let pending = pendingDeepLink, let closure = onDeepLinkReceived {
                Logger.info("🚀 [Push] Processing pending deep link after subscription: \(pending)")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    closure(pending)
                }
                pendingDeepLink = nil
            }
        }
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping @Sendable () -> Void
    ) {
        let link = response.notification.request.content.userInfo["link"] as? String
        
        DispatchQueue.main.async { [weak self] in
            Logger.info("🔔 [Push Received] Link extracted: \(link ?? "NIL")")
            
            if let link, let url = URL(string: link) {
                if let closure = self?.onDeepLinkReceived {
                    Logger.info("✅ 'onDeepLinkReceived' exists, sending URL: \(url)")
                    
                    // App Case in Foreground/Background:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        closure(url)
                    }
                } else {
                    Logger.debug("⚠️ 'onDeepLinkReceived' is NIL. Saving pending URL...")
                    self?.pendingDeepLink = url
                }
            }
            completionHandler()
        }
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping @Sendable (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .list])
    }
}
