//
//  UIDevice+HCI.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/9.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

extension UIDevice {
    
    var manufacturer: String {
        return "Apple"
    }
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    var platform: String {
        #if os(iOS)
            return "iOS"
        #elseif os(watchOS)
            return "watchOS"
        #elseif os(tvOS)
            return "tvOS"
        #elseif os(macOS) || os(OSX)
            return "macOS"
        #else
            return "unknown OS"
        #endif
    }
}
