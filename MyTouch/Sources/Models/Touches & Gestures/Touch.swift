//
//  RawTouch.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/29.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit
import ResearchKit

extension Touch {
    
    enum Phase: String, Codable {
        case began
        case moved
        case stationary
        case ended
        case cancelled
        
        init(phase: UITouch.Phase) {
            switch phase {
            case .began:      self = .began
            case .moved:      self = .moved
            case .stationary: self = .stationary
            case .ended:      self = .ended
            case .cancelled:  self = .cancelled
            }
        }
    }
    
    enum TouchType: String, Codable {
        case direct // A direct touch from a finger (on a screen)
        case indirect // An indirect touch (not a screen)
        case pencil // Add pencil name variant
        
        init(touchType: UITouch.TouchType) {
            switch touchType {
            case .direct:   self = .direct
            case .indirect: self = .indirect
            case .pencil:   self = .pencil
            }
        }
    }
    
    struct Properties: OptionSet, Codable {
       
        var rawValue: Int
        
        static var force    = Properties(rawValue: 1 << 0)
        static var azimuth  = Properties(rawValue: 1 << 1)
        static var altitude = Properties(rawValue: 1 << 2)
        static var location = Properties(rawValue: 1 << 3) // For predicted Touches
        
        static func convert(from: UITouch.Properties) -> Properties {
            var properties: Properties = []
            if from.contains(.force) {
                properties.insert(.force)
            }
            if from.contains(.azimuth) {
                properties.insert(.azimuth)
            }
            if from.contains(.altitude) {
                properties.insert(.altitude)
            }
            if from.contains(.location) {
                properties.insert(.location)
            }
            return properties
        }
    }
    
}

class Touch: Codable {
    
    var timestamp: TimeInterval
    
    var phase: Touch.Phase
    
    var tapCount: UInt
    
    var type: Touch.TouchType
    
    var majorRadius: CGFloat
    
    var majorRadiusTolerance: CGFloat
    
    var location: CGPoint
    
    var previousLocation: CGPoint
    
    var preciseLocation: CGPoint
    
    var precisePreviousLocation: CGPoint
    
    // Force of the touch, where 1.0 represents the force of an average touch
    var force: CGFloat
    
    // Maximum possible force with this input mechanism
    var maximumPossibleForce: CGFloat
    
    // Azimuth angle. Valid only for stylus touch types. Zero radians points along the positive X axis.
    // Passing a nil for the view parameter will return the azimuth relative to the touch's window.
    var azimuthAngle: CGFloat
    
    // A unit vector that points in the direction of the azimuth angle. Valid only for stylus touch types.
    // Passing nil for the view parameter will return a unit vector relative to the touch's window.
    var azimuthUnitVector: CGVector
    
    // An index which allows you to correlate updates with the original touch.
    // Is only guaranteed non-nil if this UITouch expects or is an update.
    var estimationUpdateIndex: Double?
    
    // A set of properties that has estimated values
    // Only denoting properties that are currently estimated
    var estimatedProperties: Touch.Properties
    
    // A set of properties that expect to have incoming updates in the future.
    // If no updates are expected for an estimated property the current value is our final estimate.
    // This happens e.g. for azimuth/altitude values when entering from the edges
    var estimatedPropertiesExpectingUpdates: Touch.Properties
    
    
    init(touch: ORKTouchAbilityTouch) {
        self.timestamp               = touch.timestamp
        self.phase                   = Phase(phase: touch.phase)
        self.tapCount                = touch.tapCount
        self.type                    = TouchType(touchType: touch.type)
        self.majorRadius             = touch.majorRadius
        self.majorRadiusTolerance    = touch.majorRadiusTolerance
        self.location                = touch.locationInWindow
        self.previousLocation        = touch.previousLocationInWindow
        self.preciseLocation         = touch.preciseLocationInWindow
        self.precisePreviousLocation = touch.precisePreviousLocationInWindow
        self.force                   = touch.force
        self.maximumPossibleForce    = touch.maximumPossibleForce
        self.azimuthAngle            = touch.azimuthAngleInWindow
        self.azimuthUnitVector       = touch.azimuthUnitVectorInWindow
        self.estimationUpdateIndex   = touch.estimationUpdateIndex?.doubleValue
        self.estimatedProperties     = Properties.convert(from: touch.estimatedProperties)
        self.estimatedPropertiesExpectingUpdates = Properties.convert(from: touch.estimatedPropertiesExpectingUpdates)
    }
}
