//
//  AppDelegate.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/29.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit
import ResearchKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Override point for customization after application launch.
        
        print(defaultApplicationSupportDirectoryPath())
        
        window?.tintColor = UIColor(hex: 0x00b894)
        
        // listen and obtain NSUbiquitousKeyValueStore
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNSUbiquitousKeyValueStoreDidChangeExternallyNotification(_:)),
            name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
            object: NSUbiquitousKeyValueStore.default
        )
        NSUbiquitousKeyValueStore.default.synchronize()
        
        // update UserDefaults acrroding to NSUbiquitousKeyValueStore
        if let id = NSUbiquitousKeyValueStore.default.string(forKey: UserDefaults.Key.userIdentity) {
            UserDefaults.standard.set(id, forKey: UserDefaults.Key.userIdentity)
            UserDefaults.standard.synchronize()
        }
        
        
        let center = UNUserNotificationCenter.current()
        // Request permission to display alerts and play sounds.
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        
        // Remote Notification
        application.registerForRemoteNotifications()
        
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        NSUbiquitousKeyValueStore.default.synchronize()
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        if let vc = window?.rootViewController as? HomeTabBarController {
            vc.reloadSessions()
        }
        completionHandler(.noData)
    }
    
    @objc private func handleNSUbiquitousKeyValueStoreDidChangeExternallyNotification(_ notification: Notification) {
        
        if let userInfo = notification.userInfo, let reason: Int = userInfo[NSUbiquitousKeyValueStoreChangeReasonKey] as? Int {
            
            switch reason {
            case NSUbiquitousKeyValueStoreInitialSyncChange, NSUbiquitousKeyValueStoreServerChange:
                
                if let id = NSUbiquitousKeyValueStore.default.string(forKey: UserDefaults.Key.userIdentity) {
                    UserDefaults.standard.set(id, forKey: UserDefaults.Key.userIdentity)
                    UserDefaults.standard.synchronize()
                }
                
            case NSUbiquitousKeyValueStoreAccountChange:
                // TODO: TBD, update local with cloud or update cloud with local?
                break
                
            default:
                break
            }
            
            print(userInfo[NSUbiquitousKeyValueStoreChangedKeysKey] as! [String])

            
            let title: String
            var message: String = ""
            switch reason {
            case NSUbiquitousKeyValueStoreServerChange:
                title = "Server change"

            case NSUbiquitousKeyValueStoreInitialSyncChange:
                // Fist launch
                title = "Initial Sync Change"

            case NSUbiquitousKeyValueStoreQuotaViolationChange:
                title = "Quota Violation Change"

            case NSUbiquitousKeyValueStoreAccountChange:
                title = "Account Change"

            default:
                title = "WTF"
            }
            
            for key in userInfo[NSUbiquitousKeyValueStoreChangedKeysKey] as! [String] {
                if let value = NSUbiquitousKeyValueStore.default.object(forKey: key) {
                    message = "\(key): \(value)"
                }
            }
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

