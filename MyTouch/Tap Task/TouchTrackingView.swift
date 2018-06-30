//
//  TouchTrackingView.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/1.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

protocol TouchTrackingViewDelegate: NSObjectProtocol {
    func touchTrackingViewDidBeginTracking(_ touchTrackingView: TouchTrackingView)
    func touchTrackingViewDidEndTracking(_ touchTrackingView: TouchTrackingView)
    func touchTrackingViewDidCancelTracking(_ touchTrackingView: TouchTrackingView)
}

extension TouchTrackingViewDelegate {
    func touchTrackingViewDidBeginTracking(_ touchTrackingView: TouchTrackingView) {}
    func touchTrackingViewDidEndTracking(_ touchTrackingView: TouchTrackingView) {}
    func touchTrackingViewDidCancelTracking(_ touchTrackingView: TouchTrackingView) {}
}

class TouchTrackingView: UIView {

    var isTrackEnabled = false
    var isVisualLogEnabled = false
    
    var delegate: TouchTrackingViewDelegate?
    
    private(set) var tracks = [[UITouch]]()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard isTrackEnabled else { return }
        
        if event?.allTouches?.count == touches.count {
            tracks.removeAll()
            delegate?.touchTrackingViewDidBeginTracking(self)
            setNeedsLayout()
        }
        
        let filteredTouches = touches
        
        for touch in filteredTouches {
            let coalescedTouches = event?.coalescedTouches(for: touch) ?? [touch]
            tracks.append(coalescedTouches)
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard isTrackEnabled else { return }
        
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
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard isTrackEnabled else { return }
        
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
        
        if tracks.filter({ $0.last!.phase != .ended }).count == 0 {
            delegate?.touchTrackingViewDidEndTracking(self)
            setNeedsLayout()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        guard isTrackEnabled else { return }
        
        tracks = tracks.filter {
            $0.last?.phase == .ended
        }
        delegate?.touchTrackingViewDidCancelTracking(self)
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for subview in subviews {
            if subview is VisualLogView {
                subview.removeFromSuperview()
            }
        }
        
        guard isVisualLogEnabled else {
            return
        }
        
        for track in tracks {
            
            if track.last?.phase != .ended {
                continue
            }
            
            let color = UIColor.random
            
            for touch in track {
                
                let view = VisualLogView()
                view.backgroundColor = color
                view.center = touch.location(in: self)
                view.frame.size = CGSize(width: 10, height: 10)
                view.layer.cornerRadius = 5
                
                self.addSubview(view)
            }
        }
    }
}

private class VisualLogView: UIView {
    
}
