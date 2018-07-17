//
//  TapTask.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/29.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import Foundation

protocol Task: Codable {
    associatedtype Trial: MyTouch.Trial
    
    var trials: [Trial] { get }
    var successRate: Float { get }
}

extension Task {
    
    var successRate: Float {
        
        if trials.count == 0 { return 0.0 }
        
        let success = trials.filter { $0.success }
        
        return Float(success.count) / Float(trials.count)
    }
}

struct TapTask: Task {
    var trials: [TapTrial] = []
}

struct SwipeTask: Task {
    var trials: [SwipeTrial] = []
}

struct DragAndDropTask: Task {
    var trials: [DragAndDropTrial] = []
}
