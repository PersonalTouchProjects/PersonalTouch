//
//  TouchTrackingViewProtocols.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/19.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

protocol TouchTrackingViewProtocol: NSObjectProtocol {
    
    var touchTrackingDelegate: TouchTrackingViewDelegate? { get set }
    
    func startTracking()
    func stopTracking()
}

protocol TrialViewProtocol: TouchTrackingViewProtocol {}

protocol TouchTrackingViewDelegate: NSObjectProtocol {
    func touchTrackingViewDidCompleteNewTracks(_ touchTrackingView: TouchTrackingViewProtocol)
}

extension TouchTrackingViewDelegate {
    func touchTrackingViewDidCompleteNewTracks(_ touchTrackingView: TouchTrackingViewProtocol) {}
}
