//
//  Exam.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/29.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

struct SessionInfo {
    let model:         String // iPad5,1
    let manufacturer:  String // always "Apple"
    let platform:      String // always "iOS"
    let osVersion:     String // 11.3.1
    let appVersion:    String // 1.0.0
    let screenSize:    CGSize
}

struct Examinee {
    
    enum Sex: String {
        case male, female
    }
    
    enum ExamineeType: String {
        case normal, cp, parkinsons
    }
    
    enum Hand: String {
        case left, right
    }
    
    let name: String
    let sex: Sex
    let birthday: Date
    let type: ExamineeType
    let stringHand: Hand
    let country: String
    let email: String
    let phoneNumber: String
    let note: String
}

struct Exam {
    
    let date: Date
  
    let sessionInfo: SessionInfo
    
    let examinee: Examinee
    
    var tapTask: TapTask?
    
    var swipeTask: SwipeTask?
    
    var dragAndDropTask: DragAndDropTask?
    
    var uploaded: Bool = false
    
    init(examinee: Examinee) {
        
        self.date = Date()
        // TODO: create session
        self.sessionInfo = SessionInfo(model: "", manufacturer: "", platform: "", osVersion: "", appVersion: "", screenSize: .zero)
        self.examinee = examinee
    }
}
