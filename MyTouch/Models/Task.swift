//
//  TapTask.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/29.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import Foundation

protocol Task {
    associatedtype Trial: MyTouch.Trial
    
    var trials: [Trial] { get }
}

struct TapTask: Task {
    var trials: [TapTrial]
}

struct SwipeTask: Task {
    var trials: [SwipeTrial]
}

struct DragAndDropTask: Task {
    var trials: [DragAndDropTrial]
}
