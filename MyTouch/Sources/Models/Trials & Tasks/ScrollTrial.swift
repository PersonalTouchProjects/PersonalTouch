//
//  ScrollTrial.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/19.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit
import ResearchKit

class ScrollTrial: Trial {
    
    var isHorizontal = false
    
    var initialOffset = CGPoint.zero
    var targetOffsetUpperBound = CGPoint.zero
    var targetOffsetLowerBound = CGPoint.zero
    var endDraggingOffset = CGPoint.zero
    var endScrollingOffset = CGPoint.zero
    
    override init(trial: ORKTouchAbilityTrial) {
        super.init(trial: trial)
        if let trial = trial as? ORKTouchAbilityScrollTrial {
            self.isHorizontal = trial.direction == .horizontal
            self.initialOffset = trial.initialOffset
            self.targetOffsetUpperBound = trial.targetOffsetUpperBound
            self.targetOffsetLowerBound = trial.targetOffsetLowerBound
            self.endDraggingOffset = trial.endDraggingOffset
            self.endScrollingOffset = trial.endScrollingOffset
        }
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}
