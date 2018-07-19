//
//  TouchTrackingViewProtocols.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/19.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

protocol TouchTrackingViewProtocol: NSObjectProtocol {
    
    var tracks: [[UITouch]] { get }
    var rawTracks: [RawTouchTrack] { get }
    
    var touchTrackingDelegate: TouchTrackingViewDelegate? { get set }
    
    func startTracking()
    func stopTracking()
}

protocol TouchTrackingViewDelegate: NSObjectProtocol {
    func touchTrackingViewDidBeginNewTrack(_ touchTrackingView: TouchTrackingViewProtocol)
    func touchTrackingViewDidCompleteNewTracks(_ touchTrackingView: TouchTrackingViewProtocol)
}

protocol TrialViewProtocol: TouchTrackingViewProtocol {
    var gestureRecognizerEvents: [GestureRecognizerEvent] { get }
}
