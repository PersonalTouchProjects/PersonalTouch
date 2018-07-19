//
//  SwipeTrial.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/29.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

struct SwipeTrial: Trial {
    
    enum Direction: String, Codable {
        case up, left, right, down
        case upLeft, upRight, downLeft, downRight
        case none
    }
    
    let areaFrame: CGRect
    
    let targetDirection: Direction
    
    var resultDirection: Direction = .none
    
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
    
    init(areaFrame: CGRect, targetDirection: Direction) {
        self.areaFrame = areaFrame
        self.targetDirection = targetDirection
    }
}
