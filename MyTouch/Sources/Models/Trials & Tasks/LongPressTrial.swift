//
//  LongPressTrial.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/8/10.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit
import ResearchKit

class LongPressTrial: Trial {
    
    var targetFrame = CGRect.zero
    var success = false
    
    override init(trial: ORKTouchAbilityTrial) {
        super.init(trial: trial)
        if let trial = trial as? ORKTouchAbilityLongPressTrial {
            self.targetFrame = trial.targetFrameInWindow
            self.success = trial.success
        }
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
