//
//  EventsManager.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/16.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class EventsManager {
    
    private(set) var tapTask = TapTask()
    
    private(set) var otherTrials: [Trial] = []
    
    func addTrial(_ newTrial: Trial) {
        if let tapTrial = newTrial as? TapTrial {
            tapTask.trials.append(tapTrial)
        } else {
            otherTrials.append(newTrial)
        }
    }
    
}
