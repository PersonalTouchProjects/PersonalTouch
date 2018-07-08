//
//  GestureRecognizerEvent.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/7.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

enum GestureRecognizerEventState: String, Codable {
    case possible
    case began
    case changed
    case ended
    case cancelled
    case failed
    
    init(state: UIGestureRecognizerState) {
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

protocol GestureRecognizerEvent: Codable {
    
    var timestamp: TimeInterval { get }
    
    var state: GestureRecognizerEventState { get } // the current state of the gesture recognizer
    
    var allowedTouchTypes: [Double] { get } // Array of UITouchTypes as NSNumbers.
    
    var location: CGPoint { get }
    
    var numberOfTouches: Int { get }
    
    var locationOfTouchAtIndex: [Int: CGPoint] { get }
}


/// TapGestureRecognizerEvent
struct TapGestureRecognizerEvent: GestureRecognizerEvent {
    
    var numberOfTapsRequired: Int // Default is 1. The number of taps required to match
    
    var numberOfTouchesRequired: Int // Default is 1. The number of fingers required to match
    
    
    
    var timestamp: TimeInterval
    
    var state: GestureRecognizerEventState
    
    var allowedTouchTypes: [Double]
    
    var location: CGPoint
    
    var numberOfTouches: Int // number of touches involved for which locations can be queried
    
    var locationOfTouchAtIndex: [Int: CGPoint] // the location of a particular touch
    
    init(recognizer: UITapGestureRecognizer) {
        self.numberOfTapsRequired    = recognizer.numberOfTapsRequired
        self.numberOfTouchesRequired = recognizer.numberOfTouchesRequired
        
        self.timestamp         = Date().timeIntervalSince1970
        self.state             = GestureRecognizerEventState(state: recognizer.state)
        self.allowedTouchTypes = recognizer.allowedTouchTypes.map { $0.doubleValue }
        self.location          = recognizer.location(in: nil)
        self.numberOfTouches   = recognizer.numberOfTouches
        
        if recognizer.numberOfTouches > 0 {
            self.locationOfTouchAtIndex = (0..<recognizer.numberOfTouches).reduce([Int: CGPoint]()) { result, index in
                let location = recognizer.location(ofTouch: index, in: nil)
                var result = result
                result[index] = location
                return result
            }
        } else {
            self.locationOfTouchAtIndex = [:]
        }
    }
}


/// LongPressGestureRecognizerEvent
struct LongPressGestureRecognizerEvent: GestureRecognizerEvent {
    
    var numberOfTapsRequired: Int // Default is 1. The number of taps required to match
    
    var numberOfTouchesRequired: Int // Default is 1. The number of fingers required to match
    
    var minimumPressDuration: TimeInterval // Default is 0.5. Time in seconds the fingers must be held down for the gesture to be recognized
    
    var allowableMovement: CGFloat // Default is 10. Maximum movement in pixels allowed before the gesture fails. Once recognized (after minimumPressDuration) there is no limit on finger movement for the remainder of the touch tracking
    
    
    
    var timestamp: TimeInterval
    
    var state: GestureRecognizerEventState
    
    var allowedTouchTypes: [Double]
    
    var location: CGPoint
    
    var numberOfTouches: Int // number of touches involved for which locations can be queried
    
    var locationOfTouchAtIndex: [Int: CGPoint] // the location of a particular touch
    
    init(recognizer: UILongPressGestureRecognizer) {
        self.numberOfTapsRequired    = recognizer.numberOfTapsRequired
        self.numberOfTouchesRequired = recognizer.numberOfTouchesRequired
        self.minimumPressDuration    = recognizer.minimumPressDuration
        self.allowableMovement       = recognizer.allowableMovement
        
        self.timestamp         = Date().timeIntervalSince1970
        self.state             = GestureRecognizerEventState(state: recognizer.state)
        self.allowedTouchTypes = recognizer.allowedTouchTypes.map { $0.doubleValue }
        self.location          = recognizer.location(in: nil)
        self.numberOfTouches   = recognizer.numberOfTouches
        
        if recognizer.numberOfTouches > 0 {
            self.locationOfTouchAtIndex = (0..<recognizer.numberOfTouches).reduce([Int: CGPoint]()) { result, index in
                let location = recognizer.location(ofTouch: index, in: nil)
                var result = result
                result[index] = location
                return result
            }
        } else {
            self.locationOfTouchAtIndex = [:]
        }
    }
}


/// PanGestureRecognizerEvent
struct PanGestureRecognizerEvent: GestureRecognizerEvent {
    
    var minimumNumberOfTouches: Int // default is 1. the minimum number of touches required to match
    
    var maximumNumberOfTouches: Int // default is UINT_MAX. the maximum number of touches that can be down
    
//    var translation: CGPoint // translation in the coordinate system of the window
    
    var velocity: CGPoint // velocity of the pan in points/second in the coordinate system of the window
    
    
    
    var timestamp: TimeInterval
    
    var state: GestureRecognizerEventState
    
    var allowedTouchTypes: [Double]
    
    var location: CGPoint
    
    var numberOfTouches: Int // number of touches involved for which locations can be queried
    
    var locationOfTouchAtIndex: [Int: CGPoint] // the location of a particular touch
    
    init(recognizer: UIPanGestureRecognizer) {
        self.minimumNumberOfTouches = recognizer.minimumNumberOfTouches
        self.maximumNumberOfTouches = recognizer.maximumNumberOfTouches
//        self.translation            = recognizer.translation(in: nil)
        self.velocity               = recognizer.velocity(in: nil)
        
        self.timestamp         = Date().timeIntervalSince1970
        self.state             = GestureRecognizerEventState(state: recognizer.state)
        self.allowedTouchTypes = recognizer.allowedTouchTypes.map { $0.doubleValue }
        self.location          = recognizer.location(in: nil)
        self.numberOfTouches   = recognizer.numberOfTouches
        
        if recognizer.numberOfTouches > 0 {
            self.locationOfTouchAtIndex = (0..<recognizer.numberOfTouches).reduce([Int: CGPoint]()) { result, index in
                let location = recognizer.location(ofTouch: index, in: nil)
                var result = result
                result[index] = location
                return result
            }
        } else {
            self.locationOfTouchAtIndex = [:]
        }
    }
}


/// SwipeGestureRecognizerEvent
struct SwipeGestureRecognizerEvent: GestureRecognizerEvent {
    
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
    
    var numberOfTouchesRequired: Int // default is 1. the number of fingers that must swipe
    
    var direction: SwipeGestureRecognizerEvent.Direction // the desired direction of the swipe.
    
    
    
    var timestamp: TimeInterval
    
    var state: GestureRecognizerEventState
    
    var allowedTouchTypes: [Double]
    
    var location: CGPoint
    
    var numberOfTouches: Int // number of touches involved for which locations can be queried
    
    var locationOfTouchAtIndex: [Int: CGPoint] // the location of a particular touch
    
    init(recognizer: UISwipeGestureRecognizer) {
        self.numberOfTouchesRequired = recognizer.numberOfTouchesRequired
        self.direction = Direction.convert(from: recognizer.direction)
        
        self.timestamp         = Date().timeIntervalSince1970
        self.state             = GestureRecognizerEventState(state: recognizer.state)
        self.allowedTouchTypes = recognizer.allowedTouchTypes.map { $0.doubleValue }
        self.location          = recognizer.location(in: nil)
        self.numberOfTouches   = recognizer.numberOfTouches
        
        if recognizer.numberOfTouches > 0 {
            self.locationOfTouchAtIndex = (0..<recognizer.numberOfTouches).reduce([Int: CGPoint]()) { result, index in
                let location = recognizer.location(ofTouch: index, in: nil)
                var result = result
                result[index] = location
                return result
            }
        } else {
            self.locationOfTouchAtIndex = [:]
        }
    }
}


/// PinchGestureRecognizerEvent
struct PinchGestureRecognizerEvent: GestureRecognizerEvent {
    
    var scale: CGFloat // scale relative to the touch points in screen coordinates
    
    var velocity: CGFloat // velocity of the pinch in scale/second
    
    
    
    var timestamp: TimeInterval
    
    var state: GestureRecognizerEventState
    
    var allowedTouchTypes: [Double]
    
    var location: CGPoint
    
    var numberOfTouches: Int // number of touches involved for which locations can be queried
    
    var locationOfTouchAtIndex: [Int: CGPoint] // the location of a particular touch
    
    init(recognizer: UIPinchGestureRecognizer) {
        self.scale    = recognizer.scale
        self.velocity = recognizer.velocity
        
        self.timestamp         = Date().timeIntervalSince1970
        self.state             = GestureRecognizerEventState(state: recognizer.state)
        self.allowedTouchTypes = recognizer.allowedTouchTypes.map { $0.doubleValue }
        self.location          = recognizer.location(in: nil)
        self.numberOfTouches   = recognizer.numberOfTouches
        
        if recognizer.numberOfTouches > 0 {
            self.locationOfTouchAtIndex = (0..<recognizer.numberOfTouches).reduce([Int: CGPoint]()) { result, index in
                let location = recognizer.location(ofTouch: index, in: nil)
                var result = result
                result[index] = location
                return result
            }
        } else {
            self.locationOfTouchAtIndex = [:]
        }
    }
}


/// RotationGestureRecognizerEvent
struct RotationGestureRecognizerEvent: GestureRecognizerEvent {
    
    var rotation: CGFloat // rotation in radians
    
    var velocity: CGFloat // velocity of the pinch in radians/second
    
    
    
    var timestamp: TimeInterval
    
    var state: GestureRecognizerEventState
    
    var allowedTouchTypes: [Double]
    
    var location: CGPoint
    
    var numberOfTouches: Int // number of touches involved for which locations can be queried
    
    var locationOfTouchAtIndex: [Int: CGPoint] // the location of a particular touch
    
    init(recognizer: UIRotationGestureRecognizer) {
        self.rotation = recognizer.rotation
        self.velocity = recognizer.velocity
        
        self.timestamp         = Date().timeIntervalSince1970
        self.state             = GestureRecognizerEventState(state: recognizer.state)
        self.allowedTouchTypes = recognizer.allowedTouchTypes.map { $0.doubleValue }
        self.location          = recognizer.location(in: nil)
        self.numberOfTouches   = recognizer.numberOfTouches
        
        if recognizer.numberOfTouches > 0 {
            self.locationOfTouchAtIndex = (0..<recognizer.numberOfTouches).reduce([Int: CGPoint]()) { result, index in
                let location = recognizer.location(ofTouch: index, in: nil)
                var result = result
                result[index] = location
                return result
            }
        } else {
            self.locationOfTouchAtIndex = [:]
        }
    }
}
