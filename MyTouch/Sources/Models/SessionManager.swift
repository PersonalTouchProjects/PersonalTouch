//
//  SessionManager.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/22.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class SessionManager {
    
    // MARK: - Singleton
    static let shared = SessionManager()
    
    
    // MARK: - Properties
    
    var currentSession: Session?
    
    var isCompleted: Bool {
        
        guard let session = currentSession else { return false }
        
        return
            (session.tapTask?.trials.count              ?? 0) != 0 &&
            (session.swipeTask?.trials.count            ?? 0) != 0 &&
            (session.dragAndDropTask?.trials.count      ?? 0) != 0 &&
            (session.horizontalScrollTask?.trials.count ?? 0) != 0 &&
            (session.verticalScrollTask?.trials.count   ?? 0) != 0 &&
            (session.pinchTask?.trials.count            ?? 0) != 0 &&
            (session.rotationTask?.trials.count         ?? 0) != 0
    }
}
