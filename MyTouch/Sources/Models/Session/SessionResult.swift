//
//  SessionResult.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/2/5.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit

class SessionResult: Codable {

    enum State: String, Codable {
        case temporary
        case pending
        case analyzing
        case completed
    }
    
    enum TouchAssistant: Codable {
        case off
        case initial(duration: TimeInterval)
        case final(duration: TimeInterval)
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let duration = try container.decode(TimeInterval.self)
            
            if duration == 0 {
                self = .off
            } else if duration > 0 {
                self = .initial(duration: duration)
            } else {
                self = .final(duration: -duration)
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .initial(let duration):
                try container.encode(duration)
            case .final(let duration):
                try container.encode(-duration)
            default:
                try container.encode(0.0)
            }
        }
        
    }
    
    var id: String = UUID().uuidString
    
    var state: State = .temporary
    
    var start: Date = .distantPast
    var end: Date = .distantFuture
    
    var deviceInfo: DeviceInfo
    var subject: Subject
    
    var holdDuration: TimeInterval?
    var ignoreRepeat: TimeInterval?
    var touchAssistant: TouchAssistant?
}
