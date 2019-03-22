//
//  AppDelegate.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/29.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit
import ResearchKit

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
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        NSUbiquitousKeyValueStore.default.synchronize()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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

