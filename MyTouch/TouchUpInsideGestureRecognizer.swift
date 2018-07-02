//
//  TouchUpInsideGestureRecognizer.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/2.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class TouchUpInsideGestureRecognizer: UIGestureRecognizer {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        self.state = .began
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        
        guard let view = self.view, let touch = touches.first else {
            self.state = .failed
            return
        }
        
        if view.bounds.contains(touch.location(in: view)) {
            self.state = .ended
        } else {
            self.state = .failed
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        self.state = .cancelled
    }
}
