//
//  SessionControllerConstants.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/2/25.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let sessionControllerDidChangeState = Notification.Name("sessionControllerDidChangeState")
}

extension SessionController {
    struct TaskUUID {
        static let consentUUID = UUID()
        static let surveyUUID = UUID()
        static let activityUUID = UUID()
    }
}
