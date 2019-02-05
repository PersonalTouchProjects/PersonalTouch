//
//  TapTask.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/29.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import Foundation
import ResearchKit

class Task<T: MyTouch.Trial>: Codable {
    var trials: [T] = []
}

final class TapTask: Task<TapTrial> {
    
    init(result: ORKTouchAbilityTapResult) {
        super.init()
        self.trials = result.trials.map { TapTrial(trial: $0) }
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

final class LongPressTask: Task<LongPressTrial> {
    
    init(result: ORKTouchAbilityLongPressResult) {
        super.init()
        self.trials = result.trials.map { LongPressTrial(trial: $0) }
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

final class SwipeTask: Task<SwipeTrial> {
    
    init(result: ORKTouchAbilitySwipeResult) {
        super.init()
        self.trials = result.trials.map { SwipeTrial(trial: $0) }
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

final class ScrollTask: Task<ScrollTrial> {
    
    init(result: ORKTouchAbilityScrollResult) {
        super.init()
        self.trials = result.trials.map { ScrollTrial(trial: $0) }
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

final class PinchTask: Task<PinchTrial> {
    
    init(result: ORKTouchAbilityPinchResult) {
        super.init()
        self.trials = result.trials.map { PinchTrial(trial: $0) }
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

final class RotationTask: Task<RotationTrial> {
    
    init(result: ORKTouchAbilityRotationResult) {
        super.init()
        self.trials = result.trials.map { RotationTrial(trial: $0) }
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
