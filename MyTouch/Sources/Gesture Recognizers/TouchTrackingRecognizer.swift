//
//  TouchTrackingRecognizer.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/19.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

protocol TouchTrackingRecognizerDelegate: NSObjectProtocol {
    func touchTrackingRecognizerDidBeginNewTrack(_ recognizer: TouchTrackingRecognizer)
    func touchTrackingRecognizerDidCompleteNewTracks(_ recognizer: TouchTrackingRecognizer)
}

final class TouchTrackingRecognizer: UIGestureRecognizer {
    
    var touchTrackingDelegate: TouchTrackingRecognizerDelegate?
    
    private(set) var systemUptime: TimeInterval = 0
    private(set) var tracks = [[UITouch]]()
    var rawTracks: [RawTouchTrack] {
        
        return tracks.compactMap { touches in
            
            if touches.isEmpty {
                return nil
            }
            
            var rawTrack = RawTouchTrack()
            for index in 0..<touches.count {
                rawTrack.addRawTouch(RawTouch(touch: touches[index], systemUptime: self.systemUptime))
            }
            
            return rawTrack
        }
    }
    private(set) var isTracking = false
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        self.delegate = self
        self.cancelsTouchesInView = false
    }
    
    func startTracking() {
        resetTracks()
        let uptime = ProcessInfo.processInfo.systemUptime
        systemUptime = Date(timeIntervalSinceNow: -uptime).timeIntervalSince1970
        isTracking = true
    }
    
    func stopTracking() {
        isTracking = false
    }
    
    func resetTracks() {
        tracks.removeAll()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        
        guard isTracking else { return }
        
        touchTrackingDelegate?.touchTrackingRecognizerDidBeginNewTrack(self)
        
        let filteredTouches = touches
        
        for touch in filteredTouches {
            let coalescedTouches = event.coalescedTouches(for: touch) ?? [touch]
            tracks.append(coalescedTouches)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        
        guard isTracking else { return }
        
        let filteredTouches = touches
        
        for touch in filteredTouches {
            
            for (index, track) in tracks.enumerated() {
                
                guard let lastInTrack = track.last else { continue }
                
                if lastInTrack.phase != .ended && touch.previousLocation(in: nil) == lastInTrack.location(in: nil) {
                    
                    let coalescedTouches = event.coalescedTouches(for: touch) ?? [touch]
                    tracks[index] += coalescedTouches
                }
            }
        }
    }
    
    // TODO: check if work for pinch and rotation gesture
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        
        guard isTracking else { return }
        
        let filteredTouches = touches
        
        for touch in filteredTouches {
            
            for (index, track) in tracks.enumerated() {
                
                guard let lastInTrack = track.last else { continue }
                
                if lastInTrack.phase != .ended && touch.previousLocation(in: nil) == lastInTrack.location(in: nil) {
                    
                    let coalescedTouches = event.coalescedTouches(for: touch) ?? [touch]
                    tracks[index] += coalescedTouches
                }
            }
        }
        
        if tracks.filter({ $0.last!.isEndedOrCancelled == false }).count == 0 {
             touchTrackingDelegate?.touchTrackingRecognizerDidCompleteNewTracks(self)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        
        guard isTracking else { return }
        
        let filteredTouches = touches
        
        for touch in filteredTouches {
            
            for (index, track) in tracks.enumerated() {
                
                guard let lastInTrack = track.last else { continue }
                
                if lastInTrack.phase != .ended && touch.previousLocation(in: nil) == lastInTrack.location(in: nil) {
                    
                    let coalescedTouches = event.coalescedTouches(for: touch) ?? [touch]
                    tracks[index] += coalescedTouches
                }
            }
        }
        
        if tracks.filter({ $0.last!.isEndedOrCancelled == false }).count == 0 {
             touchTrackingDelegate?.touchTrackingRecognizerDidCompleteNewTracks(self)
        }
    }
}

extension TouchTrackingRecognizer: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}

private extension UITouch {
    
    var isEndedOrCancelled: Bool {
        return self.phase == .ended || self.phase == .cancelled
    }
}
