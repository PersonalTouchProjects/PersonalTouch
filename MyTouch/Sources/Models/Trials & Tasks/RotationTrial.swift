//
//  RotationTrial.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/20.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit
import ResearchKit

class RotationTrial: Trial {
    
    var targetRotation: CGFloat = 0.0
    var resultRotation: CGFloat = 0.0
    
    override init(trial: ORKTouchAbilityTrial) {
        super.init(trial: trial)
        if let trial = trial as? ORKTouchAbilityRotationTrial {
            self.targetRotation = trial.targetRotation
            self.resultRotation = trial.resultRotation
        }
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
