//
//  Trial.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/29.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import Foundation
import ResearchKit

class Trial: Codable {
    
    var startDate = Date.distantPast
    
    var endDate = Date.distantFuture
    
    var tracks = [Track]()
    
    var events = [GestureRecognizerEvent]()
    
    init(trial: ORKTouchAbilityTrial) {
        self.startDate = trial.startDate
        self.endDate = trial.endDate
        self.tracks = trial.tracks.map({ Track(track: $0) })
        self.events = trial.gestureRecognizerEvents.map { event in
            if let event = event as? ORKTouchAbilityTapGestureRecoginzerEvent {
                return TapGestureRecognizerEvent(event: event)
            } else if let event = event as? ORKTouchAbilityLongPressGestureRecoginzerEvent {
                return LongPressGestureRecognizerEvent(event: event)
            } else if let event = event as? ORKTouchAbilitySwipeGestureRecoginzerEvent {
                return SwipeGestureRecognizerEvent(event: event)
            } else if let event = event as? ORKTouchAbilityPanGestureRecoginzerEvent {
                return PanGestureRecognizerEvent(event: event)
            } else if let event = event as? ORKTouchAbilityPinchGestureRecoginzerEvent {
                return PinchGestureRecognizerEvent(event: event)
            } else if let event = event as? ORKTouchAbilityRotationGestureRecoginzerEvent {
                return RotationGestureRecognizerEvent(event: event)
            } else {
                return GestureRecognizerEvent(event: event)
            }
        }
    }
}

//extension Trial {
//
//    var allEvents: [GestureRecognizerEvent] {
//
//        get {
//            var events = [GestureRecognizerEvent]()
//            events += tapEvents       as [GestureRecognizerEvent]
//            events += panEvents       as [GestureRecognizerEvent]
//            events += longPressEvents as [GestureRecognizerEvent]
//            events += swipeEvents     as [GestureRecognizerEvent]
//            events += pinchEvents     as [GestureRecognizerEvent]
//            events += rotationEvents  as [GestureRecognizerEvent]
//            return events
//        }
//
//        set {
//            tapEvents       += newValue.filter({ $0 is TapGestureRecognizerEvent })       as! [TapGestureRecognizerEvent]
//            panEvents       += newValue.filter({ $0 is PanGestureRecognizerEvent })       as! [PanGestureRecognizerEvent]
//            longPressEvents += newValue.filter({ $0 is LongPressGestureRecognizerEvent }) as! [LongPressGestureRecognizerEvent]
//            swipeEvents     += newValue.filter({ $0 is SwipeGestureRecognizerEvent })     as! [SwipeGestureRecognizerEvent]
//            pinchEvents     += newValue.filter({ $0 is PinchGestureRecognizerEvent })     as! [PinchGestureRecognizerEvent]
//            rotationEvents  += newValue.filter({ $0 is RotationGestureRecognizerEvent })  as! [RotationGestureRecognizerEvent]
//        }
//    }
//
//}
