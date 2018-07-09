//
//  UIApplication+HCI.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/9.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

extension UIApplication {
    
    var appVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "N/A"
    }
    
    var appBuild: String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? "N/A"
    }
}
