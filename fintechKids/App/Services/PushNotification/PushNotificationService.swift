//
//  PushNotificationService.swift
//  fintechKids
//
//  Created by Fredy Leon on 29/12/25.
//

import UIKit
import Foundation
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import FHKCore

/// A service responsible for managing push notification lifecycle, Firebase Cloud Messaging (FCM) integration,
/// and deep link propagation through the application.
///
/// This service conforms to `ApplicationService` to stay decoupled from the main `AppDelegate`.
final class PushNotificationService: NSObject, ApplicationService {
    
    /// A processor that handles incoming URLs from notification payloads to trigger navigation.
    private var deepLinkProcessor: DeepLinkRouterProtocol?

    /// Updates the deep link processor instance.
    /// - Parameter processor: An object conforming to `DeepLinkRouterProtocol` used to manage app navigation.
    func updateRouter(_ processor: DeepLinkRouterProtocol) {
        self.deepLinkProcessor = processor
    }
    
    /// Configures the notification center and Firebase Messaging delegates upon app launch.
    /// - Parameters:
    ///   - application: The singleton app object.
    ///   - launchOptions: A dictionary indicating the reason the app was launched (if any).
    /// - Returns: A boolean value indicating whether the app can handle the launch process.
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        // Assigning delegates to handle notification interactions and FCM token updates
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        // Asynchronously request user authorization for push notifications
        Task {
            await requestAuthorization()
        }
        
        return true
    }
    
    /// Links the APNs device token to Firebase Messaging.
    /// - Parameters:
    ///   - application: The singleton app object.
    ///   - deviceToken: A globally unique token that identifies this device to APNs.
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    /// Requests notification permissions from the user and registers for remote notifications if granted.
    /// Supports alert, badge, and sound options.
    private func requestAuthorization() async {
        let center = UNUserNotificationCenter.current()
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
            if granted {
                // Registration must be performed on the Main Thread
                await MainActor.run {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        } catch {
            print("PushNotificationService: Error requesting authorization: \(error)")
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension PushNotificationService: UNUserNotificationCenterDelegate {
    
    /// Handles the user's response to a delivered notification (e.g., tapping on a banner).
    /// Extracts the "link" key from the payload and forwards it to the deep link processor.
    /// - Parameters:
    ///   - center: The notification center for the app.
    ///   - response: The user's response to the notification.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        
        // Check for deep link URL in the Firebase payload
        if let link = userInfo["link"] as? String, let url = URL(string: link) {
            await MainActor.run {
                deepLinkProcessor?.handle(url: url)
            }
        }
    }
    
    /// Determines how to present a notification when the app is in the foreground.
    /// - Parameters:
    ///   - center: The notification center for the app.
    ///   - notification: The notification that is about to be delivered.
    /// - Returns: Options for presenting the notification (Banner, Sound, and List are enabled).
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.banner, .sound, .list]
    }
}

// MARK: - MessagingDelegate
extension PushNotificationService: MessagingDelegate {
    
    /// Invoked when a new FCM registration token has been generated or updated.
    /// - Parameters:
    ///   - messaging: The Firebase Messaging instance.
    ///   - fcmToken: The new registration token string.
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("PushNotificationService: Firebase Registration Token: \(String(describing: fcmToken))")
        // Note: You should send this token to your backend server here.
    }
}
