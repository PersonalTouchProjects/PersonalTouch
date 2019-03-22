//
//  UserDefaults+HCI.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/3/2.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit

extension UserDefaults {
    
    struct Key {
        static let consented = "\(Bundle.main.bundleIdentifier!).consented"
        static let localSessions = "\(Bundle.main.bundleIdentifier!).localSessions"
        static let latestSubject = "\(Bundle.main.bundleIdentifier!).latestSubject"
        static let userIdentity = "\(Bundle.main.bundleIdentifier!).userIdentity"
    }
}
