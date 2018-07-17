//
//  TapTrial.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/29.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

struct TapTrial: Trial {
    
    let targetLocation: CGPoint
    
    var startTime: TimeInterval = Date.distantPast.timeIntervalSince1970
    
    var endTime: TimeInterval = Date.distantFuture.timeIntervalSince1970
    
    var rawTouchTracks: [RawTouchTrack] = []
    
    var success: Bool = false
    
    var gestureRecognizerEvents: [GestureRecognizerEvent] = []
    
    init(targetLocation: CGPoint) {
        self.targetLocation = targetLocation
    }
}
