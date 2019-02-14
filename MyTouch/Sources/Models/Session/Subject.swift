//
//  Participant.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/9.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import Foundation

struct Subject: Codable {
    
    enum Gender: String, Codable {
        case female, male, other
    }

    enum DominantHand: String, Codable {
        case left, right, both, none
    }
    
    let id: Int = 0
    var name: String = "John Doe"
    var birthYear: Int = 1991
    var gender: Gender = .other
    var dominantHand: DominantHand = .none
    
    var note: String?
    
}
