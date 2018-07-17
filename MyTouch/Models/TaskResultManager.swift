//
//  EventsManager.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/16.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TaskResultManager {
    
    var session: Session
    
    private(set) var otherTrials: [Trial] = []
    
    func addTrial(_ newTrial: Trial) {
        if let tapTrial = newTrial as? TapTrial {
            if session.tapTask == nil {
                session.tapTask = TapTask()
            }
            session.tapTask?.trials.append(tapTrial)
        }
        else if let swipeTrial = newTrial as? SwipeTrial {
            if session.swipeTask == nil {
                session.swipeTask = SwipeTask()
            }
            session.swipeTask?.trials.append(swipeTrial)
        }
        else if let dragTrial = newTrial as? DragAndDropTrial {
            if session.dragAndDropTask == nil {
                session.dragAndDropTask = DragAndDropTask()
            }
            session.dragAndDropTask?.trials.append(dragTrial)
        }
        else {
            otherTrials.append(newTrial)
        }
    }
    
    init(session: Session) {
        self.session = session
    }
}
