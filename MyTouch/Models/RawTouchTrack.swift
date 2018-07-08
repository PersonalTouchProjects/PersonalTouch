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
    
    init() {
        self.rawTouches = []
    }
    
    init(rawTouch: RawTouch) {
        self.rawTouches = [rawTouch]
    }
    
    mutating func addRawTouch(_ rawTouch: RawTouch) {
        rawTouches.append(rawTouch)
    }
    
}
