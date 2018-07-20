//
//  TapTask.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/29.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import Foundation

protocol Task: Codable {
    associatedtype Trial: MyTouch.Trial
    
    var trials: [Trial] { get }
    var successRate: Float { get }
}

extension Task {
    
    var successRate: Float {
        
        if trials.count == 0 { return 0.0 }
        
        let success = trials.filter { $0.success }
        
        return Float(success.count) / Float(trials.count)
    }
}

// MARK: - Tap Task

struct TapTask: Task {
    var trials: [TapTrial] = []
    
    enum CodingKeys: CodingKey {
        case trials, successRate
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(trials, forKey: .trials)
        try container.encode(successRate, forKey: .successRate)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        trials = try container.decode([TapTrial].self, forKey: .trials)
    }
    
    init() {}
}

// MARK: - Swipe Task

struct SwipeTask: Task {
    var trials: [SwipeTrial] = []
    
    enum CodingKeys: CodingKey {
        case trials, successRate
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(trials, forKey: .trials)
        try container.encode(successRate, forKey: .successRate)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        trials = try container.decode([SwipeTrial].self, forKey: .trials)
    }
    
    init() {}
}

// MARK: - Drag And Drop Task

struct DragAndDropTask: Task {
    var trials: [DragAndDropTrial] = []
    
    enum CodingKeys: CodingKey {
        case trials, successRate
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(trials, forKey: .trials)
        try container.encode(successRate, forKey: .successRate)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        trials = try container.decode([DragAndDropTrial].self, forKey: .trials)
    }
    
    init() {}
}

// MARK: - Scroll Task

struct ScrollTask: Task {
    var trials: [ScrollTrial] = []
    
    enum CodingKeys: CodingKey {
        case trials, successRate
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(trials, forKey: .trials)
        try container.encode(successRate, forKey: .successRate)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        trials = try container.decode([ScrollTrial].self, forKey: .trials)
    }
    
    init() {}
}

// MARK: - Pinch Task

struct PinchTask: Task {
    var trials: [PinchTrial] = []
    
    enum CodingKeys: CodingKey {
        case trials, successRate
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(trials, forKey: .trials)
        try container.encode(successRate, forKey: .successRate)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        trials = try container.decode([PinchTrial].self, forKey: .trials)
    }
    
    init() {}
}

// MARK: - Rotation Task

struct RotationTask: Task {
    var trials: [RotationTrial] = []
    
    enum CodingKeys: CodingKey {
        case trials, successRate
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(trials, forKey: .trials)
        try container.encode(successRate, forKey: .successRate)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        trials = try container.decode([RotationTrial].self, forKey: .trials)
    }
    
    init() {}
}
