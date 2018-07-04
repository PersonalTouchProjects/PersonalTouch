//
//  RawTouch.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/29.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

extension RawTouch {
    
    enum Phase: Int, Codable {
        case began
        case moved
        case stationary
        case ended
        case cancelled
    }
    
    enum TouchType: Int, Codable {
        case direct // A direct touch from a finger (on a screen)
        case indirect // An indirect touch (not a screen)
        case pencil // Add pencil name variant
    }
    
    struct Properties: OptionSet, Codable {
       
        var rawValue: Int
        
        static var force    = UITouch.Properties(rawValue: 1 << 0)
        static var azimuth  = UITouch.Properties(rawValue: 1 << 1)
        static var altitude = UITouch.Properties(rawValue: 1 << 2)
        static var location = UITouch.Properties(rawValue: 1 << 3) // For predicted Touches
    }
}

struct RawTouch: Codable {
    
    var timestamp: TimeInterval
    
    var phase: RawTouch.Phase
    
    var tapCount: Int
    
    var type: RawTouch.TouchType
    
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
    var estimatedProperties: RawTouch.Properties
    
    // A set of properties that expect to have incoming updates in the future.
    // If no updates are expected for an estimated property the current value is our final estimate.
    // This happens e.g. for azimuth/altitude values when entering from the edges
    var estimatedPropertiesExpectingUpdates: RawTouch.Properties
}

//extension UITouch {
//
//    var rawTouch: RawTouch {
//        return RawTouch(
//            timestamp: self.timestamp,
//            location: self.location(in: nil),
//            previousLocation: self.previousLocation(in: nil),
//            radius: self.majorRadius,
//            radiusTolerance: self.majorRadiusTolerance
//        )
//    }
//}
