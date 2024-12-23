# **feat_fcm**

A **Swift Package** for integrating **Firebase Cloud Messaging (FCM)** with APNs (Apple Push Notification Service) on iOS.

---

## **Overview**

`feat_fcm` is a lightweight Swift package designed to simplify push notification management using **Firebase Cloud Messaging**. It includes:

- **FCM Token Management**
- **APNs Integration**
- **Topic Subscription Management**
- **Push Notification Handling**

This module is compatible with **iOS 16+** and **Swift 5.7+**.

---

## **Features**

- ✅ **FCM Token Management**: Retrieve, store, and manage FCM tokens.
- ✅ **APNs Integration**: Automatically handle APNs tokens and link with FCM.
- ✅ **Push Notification Handling**: Support for receiving and processing push notifications.
- ✅ **Topic Subscriptions**: Subscribe or unsubscribe from FCM topics.

---

## **Requirements**

| Requirement     | Minimum Version         |
|------------------|-------------------------|
| **iOS**         | 16.0                    |
| **Swift**       | 5.7                     |
| **Xcode**       | 14.0                    |
| **Firebase SDK**| Latest                  |

---

## **Installation**

### **Swift Package Manager (SPM)**

1. Open your project in **Xcode**.
2. Go to **File > Add Packages...**.
3. Enter the repository URL:  https://github.com/netcanis/feat_fcm.git
4. Select the desired version and integrate the package into your project.

---

## **Setup**

1. **Install Firebase**

Ensure you have Firebase installed in your project. Follow the [Firebase iOS Setup Guide](https://firebase.google.com/docs/ios/setup) to integrate Firebase.

2. **Enable Push Notifications**

- Enable Push Notifications capability in Xcode.
- Ensure Firebase Cloud Messaging is set up correctly in the Firebase Console.

---

## **Usage**

### **1. Configure FCM Manager**

To set up and initialize FCM:

```swift
import feat_fcm

// Configure FCM manager
HiFCMManager.shared.configure()

// FCM Token Received Callback
HiFCMManager.shared.onTokenReceived = { token in
    print("Received FCM Token: \(token)")
}

// Push Notification Received Callback
HiFCMManager.shared.onPushReceived = { notification in
    print("Push Notification Received: \(notification.request.content.userInfo)")
}
```

### **2. Handle APNs Token Registration**

Add the following in your AppDelegate to register for push notifications:

```swift
import UIKit
import feat_fcm

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        HiFCMManager.shared.setAPNsToken(deviceToken)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for APNs: \(error)")
    }
}
```

### **3. Request Notification Permissions**

You can request notification permissions at runtime:

```swift
HiAPNsManager.shared.requestNotificationAuthorization()
```

### **4. Retrieve Tokens**

Retrieve the FCM token and APNs token:

```swift
let fcmToken = HiFCMManager.shared.getFCMToken()
let apnsToken = HiFCMManager.shared.getAPNsToken()
print("FCM Token: \(fcmToken)")
print("APNs Token: \(apnsToken)")
```

### **5. Subscribe to a Topic**

Subscribe or unsubscribe from FCM topics:

```swift
HiFCMManager.shared.subscribeToTopic("news")
HiFCMManager.shared.unsubscribeFromTopic("news")
```

---

## **Permissions**

Ensure you have the following permissions set in your Info.plist:

```
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>                <!-- Background Fetch -->
    <string>remote-notification</string>  <!-- Push Notification -->
</array>
```

---

## **Example UI**

Here is a simple example to display push notification tokens and logs in a SwiftUI view:

```swift
import feat_fcm
import SwiftUI

@main
struct MyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        // Configure FCM
        HiFCMManager.shared.configure()
        
        // Handle FCM token reception
        HiFCMManager.shared.onTokenReceived = { token in
            print("FCM Token Received: \(token)")
        }

        // Handle push notification events
        HiFCMManager.shared.onPushReceived = { notification in
            print("Received Push Notification: \(notification.request.content.userInfo)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                }
        }
    }
}

// AppDelegate.swift
import UIKit
import feat_fcm

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        HiFCMManager.shared.setAPNsToken(deviceToken)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for APNs: \(error)")
    }
}
```

---

## **License**

feat_qr is available under the MIT License. See the LICENSE file for details.

---

## **Contributing**

Contributions are welcome! To contribute:

1. Fork this repository.
2. Create a feature branch:
```
git checkout -b feature/your-feature
```
3. Commit your changes:
```
git commit -m "Add feature: description"
```
4. Push to the branch:
```
git push origin feature/your-feature
```
5. Submit a Pull Request.

---

## **Author**

### **netcanis**
GitHub: https://github.com/netcanis

---
