//
//  TouchTrackingView.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/1.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

protocol TouchTrackingViewDelegate: NSObjectProtocol {
    func touchTrackingViewDidCompleteNewTracks(_ touchTrackingView: TouchTrackingView)
}

extension TouchTrackingViewDelegate {
    func touchTrackingViewDidCompleteNewTracks(_ touchTrackingView: TouchTrackingView) {}
}

class TouchTrackingView: UIView {

    var isVisualLogEnabled = false {
        didSet {
            if isVisualLogEnabled == false {
                subviews.forEach {
                    if $0 is VisualLogView { $0.removeFromSuperview() }
                }
            }
        }
    }
    
    var delegate: TouchTrackingViewDelegate?
    
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
    private var isTracking = false
    private var visualLogColors = [Int: UIColor]()
    
    func startTracking() {
        reset()
        let uptime = ProcessInfo.processInfo.systemUptime
        systemUptime = Date(timeIntervalSinceNow: -uptime).timeIntervalSince1970
        isTracking = true
    }
    
    func stopTracking() {
        isTracking = false
    }
    
    func reset() {
        tracks.removeAll()
        visualLogColors.removeAll()
        subviews.forEach {
            if $0 is VisualLogView { $0.removeFromSuperview() }
        }
        setNeedsLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        isMultipleTouchEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        backgroundColor = .white
        isMultipleTouchEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
                
        guard isTracking else { return }
        
        let filteredTouches = touches
        
        for touch in filteredTouches {
            let coalescedTouches = event?.coalescedTouches(for: touch) ?? [touch]
            tracks.append(coalescedTouches)
        }
        setNeedsLayout()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard isTracking else { return }
        
        let filteredTouches = touches
        
        for touch in filteredTouches {
            
            for (index, track) in tracks.enumerated() {
                
                guard let lastInTrack = track.last else { continue }
                
                if lastInTrack.phase != .ended && touch.previousLocation(in: self) == lastInTrack.location(in: self) {
             
                    let coalescedTouches = event?.coalescedTouches(for: touch) ?? [touch]
                    tracks[index] += coalescedTouches
                }
            }
        }
        setNeedsLayout()
    }
    
    // TODO: check if work for pinch and rotation gesture
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard isTracking else { return }
        
        let filteredTouches = touches
        
        for touch in filteredTouches {
            
            for (index, track) in tracks.enumerated() {
                
                guard let lastInTrack = track.last else { continue }
                
                if lastInTrack.phase != .ended && touch.previousLocation(in: self) == lastInTrack.location(in: self) {
                    
                    let coalescedTouches = event?.coalescedTouches(for: touch) ?? [touch]
                    tracks[index] += coalescedTouches
                }
            }
        }
        
        if tracks.filter({ $0.last!.isEndedOrCancelled == false }).count == 0 {
            delegate?.touchTrackingViewDidCompleteNewTracks(self)
        }
        setNeedsLayout()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        guard isTracking else { return }
        
        let filteredTouches = touches
        
        for touch in filteredTouches {
            
            for (index, track) in tracks.enumerated() {
                
                guard let lastInTrack = track.last else { continue }
                
                if lastInTrack.phase != .ended && touch.previousLocation(in: self) == lastInTrack.location(in: self) {
                    
                    let coalescedTouches = event?.coalescedTouches(for: touch) ?? [touch]
                    tracks[index] += coalescedTouches
                }
            }
        }
        
        if tracks.filter({ $0.last!.isEndedOrCancelled == false }).count == 0 {
            delegate?.touchTrackingViewDidCompleteNewTracks(self)
        }
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard isVisualLogEnabled else {
            return
        }
        
        for (idx, track) in tracks.enumerated() {
            
            if track.last?.isEndedOrCancelled == true {
                continue
            }
            
            for subview in subviews {
                if subview is VisualLogView, subview.tag == idx {
                    subview.removeFromSuperview()
                }
            }
            
            if visualLogColors[idx] == nil {
                visualLogColors[idx] = UIColor.random
            }
            
            let color = visualLogColors[idx]
            
            for touch in track {
                
                let view = VisualLogView()
                view.tag = idx
                view.backgroundColor = color
                view.center = touch.location(in: self)
                view.frame.size = CGSize(width: 10, height: 10)
                view.layer.cornerRadius = 5

                self.addSubview(view)
            }
        }
    }
}

private final class VisualLogView: UIView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}

private extension UITouch {
    
    var isEndedOrCancelled: Bool {
        return self.phase == .ended || self.phase == .cancelled
    }
}
