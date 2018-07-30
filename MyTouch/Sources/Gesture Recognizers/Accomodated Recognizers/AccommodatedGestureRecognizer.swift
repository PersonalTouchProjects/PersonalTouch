//
//  DelayableGestureRecognizer.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/26.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class AccommodatedPanGestureRecognizer: UIPanGestureRecognizer, AccommodatedRecognizer {

    // MARK: - Touch Accommodations
    
    var holdDuration: TimeInterval? = nil
    
    var ignoreRepeat: TimeInterval? = nil
    
    var tapAssistance: AccommodatedRecognizerTapAssistance = .off
        
    private var firstTouchBeganDate: Date?
    
    override var state: UIGestureRecognizerState {
        set {
            
            guard let holdDuration = holdDuration, let beganDate = firstTouchBeganDate else {
                super.state = newValue
                return
            }
            
            if Date().timeIntervalSince(beganDate) >= holdDuration {
                firstTouchBeganDate = nil
                super.state = newValue
            }
        }
        get {
            return super.state
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        
        if holdDuration != nil, firstTouchBeganDate == nil {
            firstTouchBeganDate = Date(timeIntervalSinceNow: -ProcessInfo.processInfo.systemUptime).addingTimeInterval(event.timestamp)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        firstTouchBeganDate = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        firstTouchBeganDate = nil
    }
    
    override func reset() {
        super.reset()
        firstTouchBeganDate = nil
    }
}
