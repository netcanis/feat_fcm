//
//  HiFCMManager.swift
//  feat_fcm
//
//  Created by netcanis on 11/20/24.
//

import Foundation
import UIKit
import feat_apns
import Firebase
import FirebaseMessaging

/// A singleton class to manage Firebase Cloud Messaging (FCM) integration.
/// It handles token management, APNs integration, and topic subscriptions.
public class HiFCMManager: NSObject, @unchecked Sendable {
    /// Shared singleton instance of `HiFCMManager`.
    public static let shared = HiFCMManager()

    /// Callback for receiving FCM tokens.
    public var onTokenReceived: ((String) -> Void)?
    
    /// Callback for receiving push notifications.
    public var onPushReceived: ((UNNotification) -> Void)? {
        get { HiAPNsManager.shared.onPushReceived }
        set { HiAPNsManager.shared.onPushReceived = newValue }
    }
    
    /// Keys used to cache FCM and APNs tokens in `UserDefaults`.
    private let cachedFCMTokenKey = "HiLastFcmToken"
    private let cachedAPNsTokenKey = "HiLastAPNsToken"

    /// Private initializer to enforce singleton usage.
    private override init() {
        super.init()
    }
    
    /// Configures the FCM service.
    /// - Initializes Firebase and links APNs with FCM.
    public func configure() {
        HiAPNsManager.shared.configure() // Initialize APNs manager
        FirebaseApp.configure() // Configure Firebase
        Messaging.messaging().delegate = self // Set FCM messaging delegate
    }

    /// Registers the APNs token to Firebase.
    /// - Parameter deviceToken: The APNs device token provided by the system.
    public func setAPNsToken(_ deviceToken: Data) {
        let apnsToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("APNs Device Token: \(apnsToken)")
        UserDefaults.standard.set(apnsToken, forKey: cachedAPNsTokenKey)
        Messaging.messaging().apnsToken = deviceToken
    }

    /// Retrieves the cached APNs token.
    /// - Returns: A string representing the cached APNs token.
    public func getCachedAPNsToken() -> String {
        return UserDefaults.standard.string(forKey: cachedAPNsTokenKey) ?? ""
    }

    /// Retrieves the cached FCM token.
    /// - Returns: A string representing the cached FCM token.
    public func getCachedFCMToken() -> String {
        return UserDefaults.standard.string(forKey: cachedFCMTokenKey) ?? ""
    }

    /// Retrieves the latest FCM token from Firebase.
    /// - Returns: The current FCM token, if available.
    public func getFCMToken() -> String {
        return Messaging.messaging().fcmToken ?? ""
    }

    /// Retrieves the latest APNs token.
    /// - Returns: A string representing the current APNs token.
    public func getAPNsToken() -> String {
        guard let deviceToken = Messaging.messaging().apnsToken else {
            print("APNs token is nil. Ensure APNs registration succeeded and token is set.")
            return ""
        }

        let apnsToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        return apnsToken
    }

    /// Subscribes the device to a specified FCM topic.
    /// - Parameter topic: The name of the topic to subscribe to.
    public func subscribeToTopic(_ topic: String) {
        Messaging.messaging().subscribe(toTopic: topic) { error in
            if let error = error {
                print("Failed to subscribe to topic: \(error)")
            } else {
                print("Subscribed to topic \(topic)")
            }
        }
    }

    /// Unsubscribes the device from a specified FCM topic.
    /// - Parameter topic: The name of the topic to unsubscribe from.
    public func unsubscribeFromTopic(_ topic: String) {
        Messaging.messaging().unsubscribe(fromTopic: topic) { error in
            if let error = error {
                print("Failed to unsubscribe from topic: \(error)")
            } else {
                print("Unsubscribed from topic \(topic)")
            }
        }
    }
}

// MARK: - MessagingDelegate
extension HiFCMManager: MessagingDelegate {
    /// Triggered when the FCM registration token is updated or created.
    /// - Parameters:
    ///   - messaging: The `Messaging` instance providing the event.
    ///   - fcmToken: The new or updated FCM token.
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else { return }
        print("FCM Token: \(token)")

        let cachedToken = getCachedFCMToken()
        if token != cachedToken {
            print("FCM Token has been updated. Old: \(cachedToken), New: \(token)")
            UserDefaults.standard.set(token, forKey: cachedFCMTokenKey)
            onTokenReceived?(token) // Notify the app about the updated token
        } else {
            print("FCM Token remains unchanged: \(token)")
        }
    }
}
