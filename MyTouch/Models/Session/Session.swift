//
//  Session.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/17.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import Foundation

class Session: Codable {
    
    var startDate: Date = Date()
    
    var endDate: Date = .distantFuture
    
    var deviceInfo: DeviceInfo = DeviceInfo()
    
    var participant: Participant?
    
    var tapTask: TapTask?
    
    var swipeTask: SwipeTask?
    
    var dragAndDropTask: DragAndDropTask?
    
    enum ArchiveError: Error {
        case noParticipant
        case incomplete
    }
    
    func archive() throws {
        
//        guard let participant = participant else {
//            throw ArchiveError.noParticipant
//        }
//
//        guard let tapTask = tapTask, let swipeTask = swipeTask, let dragAndDropTask = dragAndDropTask else {
//            throw ArchiveError.incomplete
//        }
        
        self.endDate = Date()
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.nonConformingFloatEncodingStrategy = .convertToString(
            positiveInfinity: "positiveInfinity",
            negativeInfinity: "negativeInfinity",
            nan: "nan"
        )
        jsonEncoder.outputFormatting = .prettyPrinted
        
        
        let data = try jsonEncoder.encode(self)
        
        let dataPath = path(with: Date())
        print(dataPath)
        
        try data.write(to: dataPath, options: .atomic)
    }
}


// -----------------------
// MARK: - Utility Methods
// -----------------------

internal func defaultDirectoryPath() -> URL {
    var url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    url = url.appendingPathComponent("MyTouch/v1")
    
    do {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    } catch {
        print("Cannot create MyTouch directory under Application Support. error: \(error.localizedDescription)")
    }
    return url
}

internal func path(with date: Date) -> URL {
    
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(identifier: "UTC")
    formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
    
    let formatted = formatter.string(from: date)
    
    return defaultDirectoryPath().appendingPathComponent("\(formatted).json")
}

