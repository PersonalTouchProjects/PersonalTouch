//
//  EventsManager.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/16.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class EventsManager {
    
    private(set) var trials: [Trial] = []
    
    func addTrial(_ newTrial: Trial) {
        trials.append(newTrial)
    }
    
}
