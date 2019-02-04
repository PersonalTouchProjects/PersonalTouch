//
//  SwipeTrial.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/29.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit
import ResearchKit

class SwipeTrial: Trial {
    
    typealias Direction = SwipeGestureRecognizerEvent.Direction
    
    var targetDirection: Direction = []
    var resultDirection: Direction = []
    var success = false
    
    override init(trial: ORKTouchAbilityTrial) {
        super.init(trial: trial)
        if let trial = trial as? ORKTouchAbilitySwipeTrial {
            self.targetDirection = Direction.convert(from: trial.targetDirection)
            self.resultDirection = Direction.convert(from: trial.resultDirection)
            self.success = trial.success
        }
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
