//
//  RawTouchTrack.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/30.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit
import ResearchKit

class Track: Codable {
    
    var touches: [Touch] = []
    
    init(track: ORKTouchAbilityTrack) {
        self.touches = track.touches.map { Touch(touch: $0) }
    }
}
