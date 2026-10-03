//
//  FHKFirebaseTokenHandler.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 1/10/26.
//

import Foundation
import FirebaseMessaging

// MARK: - 1. FCM Token Handler
final class FHKFirebaseTokenHandler: NSObject, MessagingDelegate, Sendable {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("PushNotificationService: Firebase Registration Token: \(String(describing: fcmToken))")
        // Enviar token al backend...
    }
}
