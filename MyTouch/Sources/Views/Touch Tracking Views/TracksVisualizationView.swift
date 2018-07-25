//
//  TracksVisualizationView.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/24.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TracksVisualizationView: UIView {

    var tracks: [RawTouchTrack] = []
    private var _animationStartDate = Date.distantFuture
    private var _firstTouchTimestamp: TimeInterval?
    
    private var _colorForTrack: [Int: UIColor] = [:]
    private var _tracksToDraw: [RawTouchTrack] = [] {
        didSet { setNeedsDisplay() }
    }
    
    func startAnimating() {
        _tracksToDraw = []
        
        _animationStartDate = Date()
        _firstTouchTimestamp = tracks.reduce(TimeInterval.greatestFiniteMagnitude) { (result, track) -> TimeInterval in
            
            if let touch = track.rawTouches.first {
                return min(result, touch.timestamp)
            }
            else {
                return result
            }
        }
        
        let displayLink = CADisplayLink(target: self, selector: #selector(handleDisplayLink(_:)))
        displayLink.add(to: RunLoop.current, forMode: .commonModes)
    }
    
    override func draw(_ rect: CGRect) {
        
        let start = Date()
        
        for (index, track) in _tracksToDraw.enumerated() {
            var touches = track.rawTouches
            
            if let radius = touches.last?.majorRadius {
                let circle = UIBezierPath(
                    roundedRect: CGRect(
                        x: touches.last!.location.x - radius,
                        y: touches.last!.location.y - radius,
                        width: radius*2,
                        height: radius*2
                    ),
                    cornerRadius: radius
                )
                
                UIColor(white: 0.0, alpha: 0.5).setFill()
                circle.fill()
            }
            
            
            if _colorForTrack[index] == nil {
                _colorForTrack[index] = UIColor.random
            }
            _colorForTrack[index]?.setStroke()
            
            let path = UIBezierPath()
            path.move(to: touches.removeFirst().location)
            
            for touch in touches {
                path.addLine(to: touch.location)
            }
            
            path.lineWidth = 4
            path.stroke()
        }
        
        print(Date().timeIntervalSince(start))
    }
    
    @objc func handleDisplayLink(_ sender: CADisplayLink) {
        
        var filtered = [RawTouchTrack]()
        
        for track in tracks {
            
            var filteredTrack = RawTouchTrack()
            
            track.rawTouches.forEach { touch in
                
                if touch.timestamp - _firstTouchTimestamp! < Date().timeIntervalSince(_animationStartDate) {
                    filteredTrack.addRawTouch(touch)
                }
            }
            
            if !filteredTrack.rawTouches.isEmpty {
                filtered.append(filteredTrack)
            }
        }
        
        let filteredCount = filtered.map({ $0.rawTouches.count }).reduce(0, +)
        let tracksCount   = tracks.map({ $0.rawTouches.count }).reduce(0, +)
        if filteredCount == tracksCount {
            sender.remove(from: RunLoop.current, forMode: .commonModes)
        }
        
        _tracksToDraw = filtered
    }
}




