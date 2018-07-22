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
}
