//
//  Trial.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/29.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import Foundation

protocol Trial: Codable {
    
    var startTime: TimeInterval { get }
    
    var endTime: TimeInterval { get }
    
    var rawTouchTracks: [RawTouchTrack] { get }
    
    var success: Bool { get }
    
    
    
    var allEvents: [GestureRecognizerEvent] { set get }
    
    var tapEvents: [TapGestureRecognizerEvent] { get set }
    
    var panEvents: [PanGestureRecognizerEvent] { get set }
    
    var longPressEvents: [LongPressGestureRecognizerEvent] { get set }
    
    var swipeEvents: [SwipeGestureRecognizerEvent] { get set }
    
    var pinchEvents: [PinchGestureRecognizerEvent] { get set }
    
    var rotationEvents: [RotationGestureRecognizerEvent] { get set }
    
}

extension Trial {
    
    var allEvents: [GestureRecognizerEvent] {
        
        get {
            var events = [GestureRecognizerEvent]()
            events += tapEvents       as [GestureRecognizerEvent]
            events += panEvents       as [GestureRecognizerEvent]
            events += longPressEvents as [GestureRecognizerEvent]
            events += swipeEvents     as [GestureRecognizerEvent]
            events += pinchEvents     as [GestureRecognizerEvent]
            events += rotationEvents  as [GestureRecognizerEvent]
            return events
        }
        
        set {
            tapEvents       += newValue.filter({ $0 is TapGestureRecognizerEvent })       as! [TapGestureRecognizerEvent]
            panEvents       += newValue.filter({ $0 is PanGestureRecognizerEvent })       as! [PanGestureRecognizerEvent]
            longPressEvents += newValue.filter({ $0 is LongPressGestureRecognizerEvent }) as! [LongPressGestureRecognizerEvent]
            swipeEvents     += newValue.filter({ $0 is SwipeGestureRecognizerEvent })     as! [SwipeGestureRecognizerEvent]
            pinchEvents     += newValue.filter({ $0 is PinchGestureRecognizerEvent })     as! [PinchGestureRecognizerEvent]
            rotationEvents  += newValue.filter({ $0 is RotationGestureRecognizerEvent })  as! [RotationGestureRecognizerEvent]
        }
    }
    
}
