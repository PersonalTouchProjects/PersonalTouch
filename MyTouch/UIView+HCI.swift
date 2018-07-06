//
//  UIView+HCI.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/6.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

extension UIView {
    
    func snapshot() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
        
        defer {
            UIGraphicsEndImageContext()
        }
        
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}
