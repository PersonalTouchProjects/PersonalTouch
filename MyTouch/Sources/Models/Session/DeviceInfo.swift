//
//  DeviceInfo.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/9.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

struct DeviceInfo: Codable {
    
    let name:          String // Timmy's iPhone
    let model:         String // iPad5,1
    let manufacturer:  String // always Apple
    let platform:      String // iOS
    let osVersion:     String // 11.3.1
    let appVersion:    String // 1.0.0
    let screenSize:    CGSize
    
    init() {
        name         = UIDevice.current.name
        model        = UIDevice.current.modelName
        manufacturer = UIDevice.current.manufacturer
        platform     = UIDevice.current.platform
        osVersion    = UIDevice.current.systemName
        appVersion   = UIApplication.shared.appVersion
        screenSize   = UIScreen.main.bounds.size
    }
}
