//
//  TzuChuanGestureRecognizer.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/3.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class TzuChuanGestureRecognizer: UIGestureRecognizer {

    var minimalDistance: CGFloat = 10.0
    
    /*
        UIView coordinate is up-side-down!
       (0, 1)                          (0, 0)
           --------------------------------
           |            down              |
           |    down-left | down-right    |
           | left ----------------- right |
           |     up-left  |  up-right     |
           |             up               |
           --------------------------------
       (0, 0)                          (1, 0)
     */
    
    enum Direction: String {
        case up, left, down, right
        case upLeft, downLeft, upRight, downRight
        case none
    }
    private(set) var direction = Direction.none
    private var initialLocation: CGPoint?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        self.state = .possible
        self.direction = .none
        self.initialLocation = touches.first?.location(in: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        
        guard let currentLocation = touches.first?.location(in: nil),
            let initialLocation = initialLocation else {
            return
        }
        
        if currentLocation == initialLocation {
            self.direction = .none
            self.state = .failed
            return
        }
        
        let dx = currentLocation.x - initialLocation.x
        let dy = currentLocation.y - initialLocation.y
        
        let dz = sqrt(dx * dx + dy * dy)
        
        if dz < minimalDistance {
            self.direction = .none
            self.state = .failed
            return
        }
        
        let ratio = dy / dx
        
        if dx == 0 && dy >= 0 {
            
            self.direction = .down
            self.state = .ended
            
        } else if dx == 0 && dy < 0 {
            
            self.direction = .up
            self.state = .ended
            
        } else {
        
            var arctangent = atan(ratio) * 180 / .pi
            
            if dx < 0 && dy < 0 {
                arctangent -= 180
            } else if dx < 0 && dy > 0 {
                arctangent += 180
            }
            
            switch arctangent {
            case -157.5 ..< -112.5:
                self.direction = .upLeft
            case -112.5 ..< -67.5:
                self.direction = .up
            case -67.5 ..< -22.5:
                self.direction = .upRight
            case -22.5 ..< 22.5:
                self.direction = .right
            case 22.5 ..< 67.5:
                self.direction = .downRight
            case 67.5 ..< 112.5:
                self.direction = .down
            case 112.5 ..< 157.5:
                self.direction = .downLeft
            default:
                self.direction = .left
            }
        }
        self.state = .ended
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        self.state = .cancelled
    }
}
