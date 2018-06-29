//
//  RawTouch.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/29.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

struct RawTouch {
    
    var timestamp: TimeInterval
    
    var location: CGPoint
    
    var radius: CGFloat
    
    var radiusTolerance: CGFloat
}
