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
        case parkinsons
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
    
    var symptomStrings: [String] {
        var texts = [String]()
        if slowMovement {
            texts.append(Symptom.slowMovement.localizedString)
        }
        if rapidFatigue {
            texts.append(Symptom.rapidFatigue.localizedString)
        }
        if poorCoordination {
            texts.append(Symptom.poorCoordination.localizedString)
        }
        if lowStrength {
            texts.append(Symptom.lowStrength.localizedString)
        }
        if difficultyGripping {
            texts.append(Symptom.difficultyGripping.localizedString)
        }
        if difficultyHolding {
            texts.append(Symptom.difficultyHolding.localizedString)
        }
        if tremor {
            texts.append(Symptom.tremor.localizedString)
        }
        if spasm {
            texts.append(Symptom.spasm.localizedString)
        }
        if lackOfSensation {
            texts.append(Symptom.lackOfSensation.localizedString)
        }
        if difficultyControllingDirection {
            texts.append(Symptom.difficultyControllingDirection.localizedString)
        }
        if difficultyControllingDistance {
            texts.append(Symptom.difficultyControllingDistance.localizedString)
        }
        return texts
    }
}


extension Subject.Gender {
    
    var localizedString: String {
        switch self {
        case .female:
            return NSLocalizedString("GENDER_FEMALE", comment: "")
        case .male:
            return NSLocalizedString("GENDER_MALE", comment: "")
        case .other:
            return NSLocalizedString("GENDER_OTHER", comment: "")
        }
    }
}

extension Subject.DominantHand {
    
    var localizedString: String {
        switch self {
        case .left:
            return NSLocalizedString("DOMINANT_HAND_LEFT", comment: "")
        case .right:
            return NSLocalizedString("DOMINANT_HAND_RIGHT", comment: "")
        case .both:
            return NSLocalizedString("DOMINANT_HAND_BOTH", comment: "")
        case .none:
            return NSLocalizedString("DOMINANT_HAND_NONE", comment: "")
        }
    }
}

extension Subject.Impairment {
    
    var localizedString: String {
        switch self {
        case .parkinsons:
            return NSLocalizedString("IMPAIRMENT_PARKINSONS", comment: "")
        
        case .cerebralPalsy:
            return NSLocalizedString("IMPAIRMENT_CEREBRAL_PALSY", comment: "")
            
        case .muscularDystrophy:
            return NSLocalizedString("IMPAIRMENT_MUSCULAR_DYSTROPHY", comment: "")
            
        case .spinalCordInjury:
            return NSLocalizedString("IMPAIRMENT_SPINAL_CORD_INJURY", comment: "")
            
        case .tetraplegia:
            return NSLocalizedString("IMPAIRMENT_TETRAPLEGIA", comment: "")
            
        case .friedreichsAtaxia:
            return NSLocalizedString("IMPAIRMENT_FRIEDREICHS_ATAXIA", comment: "")
            
        case .multipleSclerosis:
            return NSLocalizedString("IMPAIRMENT_MULTIPLE_SCLEROSIS", comment: "")
            
        case .others:
            return NSLocalizedString("IMPAIRMENT_OTHERS", comment: "")
            
        case .none:
            return NSLocalizedString("IMPAIRMENT_NONE", comment: "")
        }
    }
}

extension Subject.Symptom {
    
    var localizedString: String {
        switch self {
            
        case .slowMovement:
            return NSLocalizedString("SYMPTOM_SLOW_MOVEMENT", comment: "")
            
        case .rapidFatigue:
            return NSLocalizedString("SYMPTOM_RAPID_FATIGUE", comment: "")
            
        case .poorCoordination:
            return NSLocalizedString("SYMPTOM_POOR_COORDINATION", comment: "")
            
        case .lowStrength:
            return NSLocalizedString("SYMPTOM_LOW_STRENGTH", comment: "")
            
        case .difficultyGripping:
            return NSLocalizedString("SYMPTOM_DIFFICULTY_GRIPPING", comment: "")
            
        case .difficultyHolding:
            return NSLocalizedString("SYMPTOM_DIFFICULTY_HOLDING", comment: "")
            
        case .tremor:
            return NSLocalizedString("SYMPTOM_TREMOR", comment: "")
            
        case .spasm:
            return NSLocalizedString("SYMPTOM_SPASM", comment: "")
            
        case .lackOfSensation:
            return NSLocalizedString("SYMPTOM_LACK_OF_SENSATION", comment: "")
            
        case .difficultyControllingDirection:
            return NSLocalizedString("SYMPTOM_DIFFICULTY_CONTROLLING_DIRECTION", comment: "")
            
        case .difficultyControllingDistance:
            return NSLocalizedString("SYMPTOM_DIFFICULTY_CONTROLLING_DISTANCE", comment: "")
            
        default:
            return NSLocalizedString("SYMPTOM_UNKNOWN", comment: "")
        }
    }
}
