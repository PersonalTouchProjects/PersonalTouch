//
//  UIImage+HCI.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/29.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

extension UIImage {

    func imageWithColor(_ color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        defer {
            UIGraphicsEndImageContext()
        }
        
        color.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    static func primaryButtonBackgroundImage(color: UIColor) -> UIImage? {
        return UIImage(named: "Button Shape")?.imageWithColor(color).resizableImage(withCapInsets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    static func secondaryButtonBackgroundImage(color: UIColor) -> UIImage? {
        return UIImage(named: "Button Border")?.imageWithColor(color).resizableImage(withCapInsets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
    
//    static func actionButtonBackgroundImage(color: UIColor) -> UIImage {
//
//        UIGraphicsBeginImageContextWithOptions(CGSize(width: 160, height: 36), true, 0)
//        defer {
//            UIGraphicsEndImageContext()
//        }
//
//        let context = UIGraphicsGetCurrentContext()
//        context.adde
//
//        return UIGraphicsGetImageFromCurrentImageContext()!
//
//        UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 100), false, 0)
//        let con = UIGraphicsGetCurrentContext()
//        CGContextAddEllipseInRect(con, CGRectMake(0, 0, 100, 100))
//        CGContextSetFillColorWithColor(con, UIColor.redColor().CGColor)
//        CGContextFillPath(con)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//
//    }
}
