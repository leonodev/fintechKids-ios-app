//
//  FHKPushNotificationService.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 30/9/26.
//

import UIKit
import Foundation
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import FHKCore

final class FHKPushNotificationService: NSObject, ApplicationService {
    
    private var deepLinkProcessor: DeepLinkHandler?
    private let userNotificationHandler = FHKUserNotificationHandler()
    private let fcmTokenHandler = FHKFirebaseTokenHandler()
    
    override init() {
        super.init()
    }
    
    @MainActor
    func updateRouter(_ processor: DeepLinkHandler) {
        self.deepLinkProcessor = processor
        
        // 🚀 La notificación llega directo al MainActor mediante este callback
        self.userNotificationHandler.onDeepLinkReceived = { [weak self] url in
            self?.deepLinkProcessor?.handle(url: url)
        }
    }
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = userNotificationHandler
        Messaging.messaging().delegate = fcmTokenHandler
        return true
    }
}


// MARK: - Private Helpers
extension FHKPushNotificationService {
    
    private func requestAuthorization() async {
        let center = UNUserNotificationCenter.current()
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
            if granted {
                await MainActor.run {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        } catch {
            print("PushNotificationService: Error requesting authorization: \(error)")
        }
    }
}
