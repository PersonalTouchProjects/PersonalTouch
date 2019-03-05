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
    
    struct Symptom: OptionSet {
        let rawValue: UInt
        
        static let slowMovement                   = Symptom(rawValue: 1 << 0)
        static let rapidFatigue                   = Symptom(rawValue: 1 << 1)
        static let poorCoordination               = Symptom(rawValue: 1 << 2)
        static let lowStrength                    = Symptom(rawValue: 1 << 3)
        static let difficultyGripping             = Symptom(rawValue: 1 << 4)
        static let difficultyHolding              = Symptom(rawValue: 1 << 5)
        static let tremor                         = Symptom(rawValue: 1 << 6)
        static let spasm                          = Symptom(rawValue: 1 << 7)
        static let lackOfSensation                = Symptom(rawValue: 1 << 8)
        static let difficultyControllingDirection = Symptom(rawValue: 1 << 9)
        static let difficultyControllingDistance  = Symptom(rawValue: 1 << 10)
    }
    
    enum Impairment: String, Codable {
        case parkinsonss
        case cerebralPalsy
        case muscularDystrophy
        case spinalCordInjury
        case tetraplegia
        case friedreichsAtaxia
        case multipleSclerosis
        case others
        case none
    }
    
    var id: String = UUID().uuidString
    var name: String = "John Doe"
    var birthYear: Int = 1991
    var gender: Gender = .other
    var dominantHand: DominantHand = .none
    
    var slowMovement = false
    var rapidFatigue = false
    var poorCoordination = false
    var lowStrength = false
    var difficultyGripping = false
    var difficultyHolding = false
    var tremor = false
    var spasm = false
    var lackOfSensation = false
    var difficultyControllingDirection = false
    var difficultyControllingDistance = false
    
    var impairment: Impairment = .none
    
    var note: String?
    
}
