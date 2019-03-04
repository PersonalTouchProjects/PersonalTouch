//
//  Utilities.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/2/25.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import Foundation

private let defaultPathComponent = "MyTouch/v2"
private let defaultSessionPathComponent = "sessions"

internal func defaultApplicationSupportDirectoryPath() -> URL {
    var url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    url = url.appendingPathComponent(defaultPathComponent)
    
    do {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    } catch {
        print("Cannot create MyTouch directory under Application Support. error: \(error.localizedDescription)")
    }
    return url
}

internal func defaultDocumentDirectoryPath() -> URL {
    var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    url = url.appendingPathComponent(defaultPathComponent)
    
    do {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    } catch {
        print("Cannot create MyTouch directory under Document Directory. error: \(error.localizedDescription)")
    }
    return url
}

internal func defaultSessionsDirectoryPath() -> URL {
    
    let url = defaultDocumentDirectoryPath().appendingPathComponent(defaultSessionPathComponent)
    
    do {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    } catch {
        print("Cannot create MyTouch directory under Document Directory. error: \(error.localizedDescription)")
    }
    return url
}
