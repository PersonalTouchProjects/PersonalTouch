//
//  TouchTrackingScrollView.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/19.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TouchTrackingScrollView: UIScrollView, TouchTrackingViewProtocol {
    
    // MARK: - tracking recoginzer properties
    
    private let trackingRecognizer = TouchTrackingRecognizer()

    var systemUptime: TimeInterval {
        return trackingRecognizer.systemUptime
    }
    
    var tracks: [[UITouch]] {
        return trackingRecognizer.tracks
    }
    
    var rawTracks: [RawTouchTrack] {
        return trackingRecognizer.rawTracks
    }
    
    private var isTouchTracking: Bool {
        return trackingRecognizer.isTracking
    }
    
    // end of tracking recognizer properties
    
    
    // MARK: - tracking recognizer methods
    
    func startTracking() {
        trackingRecognizer.startTracking()
    }
    
    func stopTracking() {
        trackingRecognizer.stopTracking()
    }
    
    func reset() {
        setContentOffset(contentOffset, animated: false)
        trackingRecognizer.resetTracks()
    }
    
    // end of tracking recognizer methods
    
    
    // MARK: - TouchTrackingViewProtocol
    
    var touchTrackingDelegate: TouchTrackingViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        trackingRecognizer.touchTrackingDelegate = self
        addGestureRecognizer(trackingRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - TouchTrackingRecognizerDelegate

extension TouchTrackingScrollView: TouchTrackingRecognizerDelegate {
    
    func touchTrackingRecognizerDidBeginNewTrack(_ recognizer: TouchTrackingRecognizer) {
        touchTrackingDelegate?.touchTrackingViewDidBeginNewTrack(self)
    }
    
    func touchTrackingRecognizerDidCompleteNewTracks(_ recognizer: TouchTrackingRecognizer) {
        touchTrackingDelegate?.touchTrackingViewDidCompleteNewTracks(self)
    }
}


