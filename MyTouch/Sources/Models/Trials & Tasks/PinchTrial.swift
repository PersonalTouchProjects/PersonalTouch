//
//  PinchTrial.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/20.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

struct PinchTrial: Trial {
    
    let initialSize: CGSize
    
    let targetSize: CGSize
    
    var resultSize: CGSize = .zero
    
    var startTime: TimeInterval = Date.distantPast.timeIntervalSince1970
    
    var endTime: TimeInterval = Date.distantFuture.timeIntervalSince1970
    
    var rawTouchTracks: [RawTouchTrack] = []
    
    var success: Bool = false
    
    var tapEvents: [TapGestureRecognizerEvent] = []
    
    var panEvents: [PanGestureRecognizerEvent] = []
    
    var longPressEvents: [LongPressGestureRecognizerEvent] = []
    
    var swipeEvents: [SwipeGestureRecognizerEvent] = []
    
    var pinchEvents: [PinchGestureRecognizerEvent] = []
    
    var rotationEvents: [RotationGestureRecognizerEvent] = []
    
    init(initialSize: CGSize, targetSize: CGSize) {
        self.initialSize = initialSize
        self.targetSize = targetSize
    }
}
