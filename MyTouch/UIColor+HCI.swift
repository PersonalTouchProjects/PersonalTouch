//
//  UIColor+HCI.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/30.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var random: UIColor {
        let hue:        CGFloat = CGFloat(arc4random() % 256) / 256.0 // 0.0 to 1.0
        let saturation: CGFloat = CGFloat(arc4random() % 128) / 256.0 + 0.5 // 0.5 to 1.0, away from white
        let brightness: CGFloat = CGFloat(arc4random() % 128) / 256.0 + 0.5 // 0.5 to 1.0, away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
}
