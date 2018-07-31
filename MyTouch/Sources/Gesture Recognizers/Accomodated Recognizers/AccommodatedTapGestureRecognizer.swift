//
//  AccommodatedTapGestureRecognizer.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/30.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class AccommodatedTapGestureRecognizer: UITapGestureRecognizer {
    
    
    // MARK: - Touch Accommodator
    
    private let accommodator = RecognizerAccommodator.default
    
    
    // MARK: - UIGestureRecognizer
    
    override var state: UIGestureRecognizerState {
        set {
            accommodator.challengeHoldDuration(newState: newValue) {
                super.state = newValue
            }
        }
        get {
            return super.state
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        accommodator.touchesBegan(touches, with: event) {
            super.touchesBegan(touches, with: event)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        accommodator.touchesEnded(touches, with: event) {
            super.touchesEnded(touches, with: event)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        accommodator.touchesCancelled(touches, with: event) {
            super.touchesCancelled(touches, with: event)
        }
    }
    
    override func reset() {
        super.reset()
        accommodator.resetStatus()
    }
}
