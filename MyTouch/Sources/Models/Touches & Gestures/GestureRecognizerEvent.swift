//
//  GestureRecognizerEvent.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/7.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit
import ResearchKit

enum GestureRecognizerType: String, Codable {
    case tap
    case pan
    case longPress
    case swipe
    case pinch
    case rotation
    case unknown
}

enum GestureRecognizerEventState: String, Codable {
    case possible
    case began
    case changed
    case ended
    case cancelled
    case failed
    
    init(state: UIGestureRecognizer.State) {
        switch state {
        case .possible:  self = .possible
        case .began:     self = .began
        case .changed:   self = .changed
        case .ended:     self = .ended
        case .cancelled: self = .cancelled
        case .failed:    self = .failed
        }
    }
}

class GestureRecognizerEvent: Codable {
    
    var type: GestureRecognizerType
    
    var timestamp: TimeInterval
    
    var state: GestureRecognizerEventState // the current state of the gesture recognizer
    
    var allowedTouchTypes: [Double] // Array of UITouchTypes as NSNumbers.
    
    var location: CGPoint
    
    var numberOfTouches: UInt
    
    var locationOfTouchAtIndex: [UInt: CGPoint]
    
    init(event: ORKTouchAbilityGestureRecoginzerEvent) {
        self.type              = .unknown
        self.timestamp         = event.timestamp
        self.state             = GestureRecognizerEventState(state: event.state)
        self.allowedTouchTypes = event.allowedTouchTypes.map { $0.doubleValue }
        self.location          = event.locationInWindow
        self.numberOfTouches   = event.numberOfTouches
        self.locationOfTouchAtIndex = event.locationInWindowOfTouchAtIndex.mapValues({ $0.cgPointValue }) as! [UInt : CGPoint]
    }
}


/// TapGestureRecognizerEvent
class TapGestureRecognizerEvent: GestureRecognizerEvent {
    
    var numberOfTapsRequired: UInt = 1 // Default is 1. The number of taps required to match
    
    var numberOfTouchesRequired: UInt = 1 // Default is 1. The number of fingers required to match
    
    override init(event: ORKTouchAbilityGestureRecoginzerEvent) {
        
        if let event = event as? ORKTouchAbilityTapGestureRecoginzerEvent {
            self.numberOfTapsRequired    = event.numberOfTapsRequired
            self.numberOfTouchesRequired = event.numberOfTouchesRequired
            super.init(event: event)
            self.type = .tap
        } else {
            fatalError()
        }
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}


/// LongPressGestureRecognizerEvent
class LongPressGestureRecognizerEvent: GestureRecognizerEvent {
    
    var numberOfTapsRequired: UInt // Default is 1. The number of taps required to match
    
    var numberOfTouchesRequired: UInt // Default is 1. The number of fingers required to match
    
    var minimumPressDuration: TimeInterval // Default is 0.5. Time in seconds the fingers must be held down for the gesture to be recognized
    
    var allowableMovement: CGFloat // Default is 10. Maximum movement in pixels allowed before the gesture fails. Once recognized (after minimumPressDuration) there is no limit on finger movement for the remainder of the touch tracking
    
    override init(event: ORKTouchAbilityGestureRecoginzerEvent) {
        if let event = event as? ORKTouchAbilityLongPressGestureRecoginzerEvent {
            self.numberOfTapsRequired    = event.numberOfTapsRequired
            self.numberOfTouchesRequired = event.numberOfTouchesRequired
            self.minimumPressDuration    = event.minimumPressDuration
            self.allowableMovement       = event.allowableMovement
            super.init(event: event)
            self.type = .longPress
        } else {
            fatalError()
        }
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}


/// PanGestureRecognizerEvent
class PanGestureRecognizerEvent: GestureRecognizerEvent {
    
    var minimumNumberOfTouches: UInt // default is 1. the minimum number of touches required to match
    
    var maximumNumberOfTouches: UInt // default is UINT_MAX. the maximum number of touches that can be down
    
    var velocity: CGPoint // velocity of the pan in points/second in the coordinate system of the window
    
    
    override init(event: ORKTouchAbilityGestureRecoginzerEvent) {
        if let event = event as? ORKTouchAbilityPanGestureRecoginzerEvent {
            self.minimumNumberOfTouches = event.minimumNumberOfTouches
            self.maximumNumberOfTouches = event.maximumNumberOfTouches
            self.velocity               = event.velocityInWindow
            super.init(event: event)
            self.type = .pan
        } else {
            fatalError()
        }
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}


/// SwipeGestureRecognizerEvent
class SwipeGestureRecognizerEvent: GestureRecognizerEvent {
    
    struct Direction: OptionSet, Codable {
        
        var rawValue: UInt
        
        static var right = Direction(rawValue: 1 << 0)
        static var left  = Direction(rawValue: 1 << 1)
        static var up    = Direction(rawValue: 1 << 2)
        static var down  = Direction(rawValue: 1 << 3)
        
        static func convert(from: UISwipeGestureRecognizer.Direction) -> Direction {
            var direction: Direction = []
            if from.contains(.right) {
                direction.insert(.right)
            }
            if from.contains(.left) {
                direction.insert(.left)
            }
            if from.contains(.up) {
                direction.insert(.up)
            }
            if from.contains(.down) {
                direction.insert(.down)
            }
            return direction
        }
    }
    
    var numberOfTouchesRequired: UInt // default is 1. the number of fingers that must swipe
    
    var direction: SwipeGestureRecognizerEvent.Direction // the desired direction of the swipe.
    
    override init(event: ORKTouchAbilityGestureRecoginzerEvent) {
        if let event = event as? ORKTouchAbilitySwipeGestureRecoginzerEvent {
            self.numberOfTouchesRequired = event.numberOfTouchesRequired
            self.direction = Direction.convert(from: event.direction)
            super.init(event: event)
            self.type = .swipe
        } else {
            fatalError()
        }
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}


/// PinchGestureRecognizerEvent
class PinchGestureRecognizerEvent: GestureRecognizerEvent {
    
    var scale: CGFloat // scale relative to the touch points in screen coordinates
    
    var velocity: CGFloat // velocity of the pinch in scale/second
    
    override init(event: ORKTouchAbilityGestureRecoginzerEvent) {
        if let event = event as? ORKTouchAbilityPinchGestureRecoginzerEvent {
            self.scale    = event.scale
            self.velocity = event.velocity
            super.init(event: event)
            self.type = .pinch
        } else {
            fatalError()
        }
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}


/// RotationGestureRecognizerEvent
class RotationGestureRecognizerEvent: GestureRecognizerEvent {
    
    var rotation: CGFloat // rotation in radians
    
    var velocity: CGFloat // velocity of the pinch in radians/second
    
    override init(event: ORKTouchAbilityGestureRecoginzerEvent) {
        if let event = event as? ORKTouchAbilityRotationGestureRecoginzerEvent {
            self.rotation = event.rotation
            self.velocity = event.velocity
            super.init(event: event)
            self.type = .rotation
        } else {
            fatalError()
        }
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
