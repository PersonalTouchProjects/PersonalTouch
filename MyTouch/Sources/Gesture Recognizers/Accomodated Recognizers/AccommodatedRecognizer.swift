//
//  AccomodatedRecognizer.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/30.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

enum AccommodatedRecognizerTapAssistance {
    case useInitialLocation(delay: TimeInterval)
    case useFinalLocation(delay: TimeInterval)
    case off
}

protocol AccommodatedRecognizer {
    
    var holdDuration: TimeInterval? { get }
    
    var ignoreRepeat: TimeInterval? { get }
    
    var tapAssistance: AccommodatedRecognizerTapAssistance { get }
}
