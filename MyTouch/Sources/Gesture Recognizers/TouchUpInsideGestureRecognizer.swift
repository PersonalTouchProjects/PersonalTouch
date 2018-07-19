//
//  TouchUpInsideGestureRecognizer.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/2.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

final class TouchUpInsideGestureRecognizer: UIGestureRecognizer {
    
    /// `targetView` must be subview of `self.view`.
    var targetView: UIView?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        
        guard validateViews() else {
            self.state = .failed
            return
        }
        
        self.state = .began
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        
        guard validateViews() else {
            return
        }
        
        self.state = .changed
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        
        guard validateViews() else {
            return
        }
        
        guard let view = self.view, let touch = touches.first else {
            self.state = .failed
            return
        }
        
        if targetView!.frame.contains(touch.location(in: view)) {
            self.state = .ended
        } else {
            self.state = .failed
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        
        guard validateViews() else {
            return
        }
        
        self.state = .cancelled
    }
    
    private func validateViews() -> Bool {
        
        if let view = view, let targetView = targetView {
            return view.subviews.contains(targetView)
        }
        return false
    }
}
