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
        // Remove all pending notification first.
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        
        UserDefaults.standard.set(token, forKey: UserDefaults.Key.apnsToken)
        UserDefaults.standard.synchronize()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        if let vc = window?.rootViewController as? HomeTabBarController {
            vc.reloadSessions()
        }
        completionHandler(.noData)
    }
}

