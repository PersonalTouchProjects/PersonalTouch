//
//  TapTrial.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/29.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

struct TapTrial: Trial {
    
    let targetFrame: CGRect
    
    var startTime: TimeInterval = Date.distantPast.timeIntervalSince1970
    
    var endTime: TimeInterval = Date.distantFuture.timeIntervalSince1970
    
    var rawTouches: [RawTouch] = []
    
    var success: Bool = false
    
    init(targetFrame: CGRect) {
        self.targetFrame = targetFrame
    }
}
