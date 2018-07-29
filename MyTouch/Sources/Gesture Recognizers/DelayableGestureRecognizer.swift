//
//  DelayableGestureRecognizer.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/26.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class MikePanGestureRecognizer: UIPanGestureRecognizer {


    var nextState: UIGestureRecognizerState?
    var stateDidSet: Bool = false
    
    override var state: UIGestureRecognizerState {
        set {
            switch newValue {
            case .began, .changed:
                if stateDidSet { super.state = newValue }
                else { super.state = .began }
                
            default:
                break
            }
            
        }
        get {
            return super.state
        }
    }
    
    
}
