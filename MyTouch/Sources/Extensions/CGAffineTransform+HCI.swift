//
//  CGAffineTransform+HCI.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/20.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

extension CGAffineTransform {
    
    var rotation: CGFloat {
        return atan2(b, a)
    }
}
