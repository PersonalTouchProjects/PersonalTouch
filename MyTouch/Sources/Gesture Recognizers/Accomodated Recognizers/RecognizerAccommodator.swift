//
//  AccomodatedRecognizer.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/30.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

extension RecognizerAccommodator {
    static let `default` = RecognizerAccommodator()
}

final class RecognizerAccommodator {
    
    // MARK: - Touch Accommodations
    
    enum TapAssistance {
        case useInitialLocation(delay: TimeInterval)
        case useFinalLocation(delay: TimeInterval)
        case off
    }
    
    var holdDuration: TimeInterval? {
        get {
            dispatchPrecondition(condition: .notOnQueue(holdDurationQueue))
            return holdDurationQueue.sync { _holdDuration }
        }
        set {
            dispatchPrecondition(condition: .notOnQueue(holdDurationQueue))
            holdDurationQueue.sync { _holdDuration = newValue }
        }
    }
    
    var ignoreRepeat: TimeInterval? {
        get {
            dispatchPrecondition(condition: .notOnQueue(ignoreRepeatQueue))
            return ignoreRepeatQueue.sync { _ignoreRepeat }
        }
        set {
            dispatchPrecondition(condition: .notOnQueue(ignoreRepeatQueue))
            ignoreRepeatQueue.sync { _ignoreRepeat = newValue }
        }
    }
    
    var tapAssistance: TapAssistance {
        get {
            dispatchPrecondition(condition: .notOnQueue(tapAssistanceQueue))
            return tapAssistanceQueue.sync { _tapAssistance }
        }
        set {
            dispatchPrecondition(condition: .notOnQueue(tapAssistanceQueue))
            tapAssistanceQueue.sync { _tapAssistance = newValue }
        }
    }
    
    
    // MARK: - Supporting Touch Accommodation
    
    var firstTouchBeganDate: Date? {
        get {
            dispatchPrecondition(condition: .notOnQueue(firstTouchBeganDateQueue))
            return firstTouchBeganDateQueue.sync { _firstTouchBeganDate }
        }
        set {
            dispatchPrecondition(condition: .notOnQueue(firstTouchBeganDateQueue))
            firstTouchBeganDateQueue.sync { _firstTouchBeganDate = newValue }
        }
    }
    
    var lastRecognizedDate: Date? {
        get {
            dispatchPrecondition(condition: .notOnQueue(lastRecognizedDateQueue))
            return lastRecognizedDateQueue.sync { _lastRecognizedDate }
        }
        set {
            dispatchPrecondition(condition: .notOnQueue(lastRecognizedDateQueue))
            lastRecognizedDateQueue.sync { _lastRecognizedDate = newValue }
        }
    }
    
    
    // MARK: - Atomic Queues
    
    private var holdDurationQueue = DispatchQueue(label: "holdDurationQueue", qos: DispatchQoS.userInteractive)
    
    private var ignoreRepeatQueue = DispatchQueue(label: "ignoreRepeatQueue", qos: DispatchQoS.userInteractive)
    
    private var tapAssistanceQueue = DispatchQueue(label: "tapAssistanceQueue", qos: DispatchQoS.userInteractive)
    
    private var firstTouchBeganDateQueue = DispatchQueue(label: "firstTouchBeganDateQueue", qos: DispatchQoS.userInteractive)
    
    private var lastRecognizedDateQueue = DispatchQueue(label: "lastRecognizedDateQueue", qos: DispatchQoS.userInteractive)
    
    
    // MARK: - Backed Properties
    
    private var _holdDuration: TimeInterval? = nil
    
    private var _ignoreRepeat: TimeInterval? = nil
    
    private var _tapAssistance: TapAssistance = .off
    
    
    private var _firstTouchBeganDate: Date? = nil
    
    private var _lastRecognizedDate: Date? = nil
    
    
    // MARK: - Handle Touch Event
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent, handler: @escaping () -> Void) {
        
        // Ignore Repeat
        
        if let ignoreRepeat = ignoreRepeat, let recognizedDate = lastRecognizedDate {
            
            guard Date().timeIntervalSince(recognizedDate) >= ignoreRepeat else {
                return
            }
            
            lastRecognizedDate = nil
        }
        
        // Hold Duration
        
        if let duration = holdDuration, firstTouchBeganDate == nil {
            
            firstTouchBeganDate = Date(timeIntervalSinceNow: -ProcessInfo.processInfo.systemUptime).addingTimeInterval(event.timestamp)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [beganDate = self.firstTouchBeganDate] in
                if beganDate == self.firstTouchBeganDate {
                    handler()
                }
            }
        } else {
            handler()
        }
    }

    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent, handler: @escaping () -> Void) {
        handler()
    }
    
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent, handler: @escaping () -> Void) {
        firstTouchBeganDate = nil
        handler()
    }
    
    func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent, handler: @escaping () -> Void) {
        firstTouchBeganDate = nil
        handler()
    }
    
    
    // MARK: - Methods
    
    func challengeHoldDuration(newState: UIGestureRecognizerState, pass: @escaping () -> Void) {
        
        let ignoreIfNeeded = {
            if self.ignoreRepeat != nil, newState == .ended {
                self.lastRecognizedDate = Date()
            }
        }
        
        guard let holdDuration = holdDuration, let beganDate = firstTouchBeganDate else {
            pass()
            ignoreIfNeeded()
            return
        }
        
        if Date().timeIntervalSince(beganDate) >= holdDuration {
            firstTouchBeganDate = nil
            pass()
            ignoreIfNeeded()
        }
    }
    
}
