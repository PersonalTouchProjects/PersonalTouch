//
//  SessionResult.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/2/5.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit

struct Session: Codable {

    enum State: String, Codable {
        case local
        case analyzing
        case completed
        case error
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
        
        var value: TimeInterval {
            switch self {
            case .initial(let duration):
                return duration
            case .final(let duration):
                return -duration
            default:
                return 0.0
            }
        }
    }
    
    var id: String = UUID().uuidString
    
    var state: State = .local
    
    var start: Date = .distantPast
    var end: Date = .distantFuture
    
    var deviceInfo: DeviceInfo
    var subject: Subject
    
    var holdDuration: TimeInterval?
    var ignoreRepeat: TimeInterval?
    var touchAssistant: TouchAssistant?
    
    var tap: Task<TapTrial>?
    
    var longPress: Task<LongPressTrial>?
    
    var swipe: Task<SwipeTrial>?
    
    var horizontalScroll: Task<ScrollTrial>?
    
    var verticalScroll: Task<ScrollTrial>?
    
    var pinch: Task<PinchTrial>?
    
    var rotation: Task<RotationTrial>?
    
    init(deviceInfo: DeviceInfo, subject: Subject) {
        self.deviceInfo = deviceInfo
        self.subject = subject
    }
}

extension Session.State {
    
    var color: UIColor {
        switch self {
        case .local:     return UIColor(hex: 0xb2bec3)
        case .analyzing: return UIColor(hex: 0xfdcb6e)
        case .completed: return UIColor(hex: 0x00b894)
        case .error:     return UIColor(hex: 0xd63031)
        }
    }
}

// MARK: - Local File Cache

extension Session {
    
    var filename: String {
        return fileDateFormatter.string(from: start)
    }
    
    static var directory: String {
        return "sessions"
    }
    
    func save() throws {
        
        let data = try APIClient.encoder.encode(self)
        try data.write(to: defaultSessionsDirectoryPath().appendingPathComponent(filename), options: .atomic)
    }
    
    static func locals() -> [Session] {
        
        var sessions = [Session]()
        
        do {
            let files = try FileManager.default.contentsOfDirectory(at: defaultSessionsDirectoryPath(), includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
            
            for file in files {
                let data = try Data(contentsOf: file)
                sessions.append(try APIClient.decoder.decode(Session.self, from: data))
            }
        }
        catch {
            print(error.localizedDescription)
        }
        
        return sessions
    }
}

private var fileDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    return formatter
}()
