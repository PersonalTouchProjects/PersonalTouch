//
//  Trial.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/29.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import Foundation

protocol Trial {
    
    var startTime: TimeInterval { get }
    
    var endTime: TimeInterval { get }
    
    var rawTouches: [RawTouch] { get }
    
    var success: Bool { get }
}
