//
//  PinchTrial.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/20.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit
import ResearchKit

class PinchTrial: Trial {
    
    var targetScale: CGFloat = 1.0
    var resultScale: CGFloat = 1.0
    
    override init(trial: ORKTouchAbilityTrial) {
        super.init(trial: trial)
        if let trial = trial as? ORKTouchAbilityPinchTrial {
            self.targetScale = trial.targetScale
            self.resultScale = trial.resultScale
        }
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
