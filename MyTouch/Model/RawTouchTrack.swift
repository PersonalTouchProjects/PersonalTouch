//
//  RawTouchTrack.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/30.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

struct RawTouchTrack {
    
    private(set) var rawTouches: [RawTouch]
    private(set) var ended: Bool = false
    
    init(rawTouch: RawTouch) {
        self.rawTouches = [rawTouch]
    }
    
    var currentLocation: CGPoint {
        return rawTouches.last!.location
    }
    
    mutating func addRawTouch(_ rawTouch: RawTouch) {
        rawTouches.append(rawTouch)
    }
    
    mutating func endTrack() {
        ended = true
    }
}
