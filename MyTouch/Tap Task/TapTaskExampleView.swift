//
//  TapTaskExampleView.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/30.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TapTaskExampleView: UIView {

    let targetView = UIView()
    let targetSize = CGSize(width: 80, height: 80)
    
//    private enum touchState {
//        case waiting, success, failed
//    }
//
//    private var state = touchState.waiting
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isMultipleTouchEnabled = true
        
        targetView.backgroundColor = tintColor
        targetView.layer.cornerRadius = 8.0
        
        addSubview(targetView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        targetView.frame = CGRect(
            x: bounds.midX - targetSize.width/2,
            y: bounds.midY - targetSize.width/2,
            width: targetSize.width,
            height: targetSize.height
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var tracks = [RawTouchTrack]()
    var touchContextCount = 0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if touchContextCount == 0 {
            for subview in subviews {
                if subview.tag >= 10000 {
                    subview.removeFromSuperview()
                }
            }
            tracks.removeAll()
        }
        
        let directTouches = touches//.filter({ $0.type == .direct })
        touchContextCount += directTouches.count
        
        for directTouch in directTouches {
            tracks.append(RawTouchTrack(rawTouch: directTouch.rawTouch))
        }
        
        if let prev = touches.first?.previousLocation(in: nil) {
            print("previous location: \(prev)")
        }
        if let current = touches.first?.location(in: nil) {
            print("current location: \(current)")
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        let directTouches = touches//.filter({ $0.type == .direct })
        
        for directTouch in directTouches {
            
            for (idx, track) in tracks.enumerated() {
                if directTouch.previousLocation(in: nil) == track.currentLocation && !track.ended {
                    
                    for coalescedTouch in (event?.coalescedTouches(for: directTouch) ?? [directTouch]) {
                        if coalescedTouch.location(in: nil) != coalescedTouch.previousLocation(in: nil) {
                            tracks[idx].addRawTouch(coalescedTouch.rawTouch)
                        }
                    }
                    
//                    tracks[idx].addRawTouch(directTouch.rawTouch)
                }
            }
        }
        
        if let prev = touches.first?.previousLocation(in: nil) {
            print("\(Date().timeIntervalSince1970) previous location: \(prev)")
        }
        if let current = touches.first?.location(in: nil) {
            print("\(Date().timeIntervalSince1970) current location: \(current)")
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        let directTouches = touches//.filter({ $0.type == .direct })
        touchContextCount -= directTouches.count
        
        for directTouch in directTouches {
            
            for (idx, track) in tracks.enumerated() {
                if directTouch.previousLocation(in: nil) == track.currentLocation && !track.ended {
                    for coalescedTouch in (event?.coalescedTouches(for: directTouch) ?? [directTouch]) {
                        if coalescedTouch.location(in: nil) != coalescedTouch.previousLocation(in: nil) {
                            tracks[idx].addRawTouch(coalescedTouch.rawTouch)
                        }
                    }
//                    tracks[idx].addRawTouch(directTouch.rawTouch)
                    tracks[idx].endTrack()
                }
            }
        }
        
        super.touchesEnded(touches, with: event)
        
        if touchContextCount == 0 {
            for (trackIdx, track) in tracks.enumerated() {
                
                let color = UIColor.random
                
                for (touchIdx, touch) in track.rawTouches.enumerated() {
                    
                    let view = UIView()
                    view.tag = (trackIdx+1) * 10000 + touchIdx
                    view.backgroundColor = color
                    view.center = CGPoint(
                        x: touch.location.x - self.frame.minX,
                        y: touch.location.y - self.frame.minY
                    )
                    view.frame.size = CGSize(width: 10, height: 10)
                    view.layer.cornerRadius = 5
                    
                    self.addSubview(view)
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let directTouches = touches//.filter({ $0.type == .direct })
        touchContextCount = 0
        
        for directTouch in directTouches {
            
            for (idx, track) in tracks.enumerated() {
                if directTouch.location(in: nil) == track.currentLocation {
                    tracks[idx].endTrack()
                }
            }
        }
        
        super.touchesCancelled(touches, with: event)
    }
}
