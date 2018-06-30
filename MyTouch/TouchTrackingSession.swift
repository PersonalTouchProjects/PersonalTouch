//
//  TouchSession.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/30.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TouchTrackingSession {
    
    private var _tracks = [[UITouch]]()
    var tracks = [RawTouchTrack]()
    var touchContextCount = 0
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let filteredTouches = touches
        touchContextCount += filteredTouches.count
        
        for touch in filteredTouches {
            let track = RawTouchTrack(rawTouch: touch.rawTouch)
            tracks.append(track)
        }
        
        print(event?.coalescedTouches(for: touches.first!) ?? [])
    }
    
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
    }
    
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
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
    }
    
    func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let directTouches = touches//.filter({ $0.type == .direct })
        touchContextCount = 0
        
        for directTouch in directTouches {
            
            for (idx, track) in tracks.enumerated() {
                if directTouch.location(in: nil) == track.currentLocation {
                    tracks[idx].endTrack()
                }
            }
        }
    }
}
