//
//  TapTask.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/29.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import Foundation

class Task<T: MyTouch.Trial>: Codable {
    
    var trials: [T] = []
    
    var successRate: Float {
        
        if trials.count == 0 { return 0.0 }
        
        let success = trials.filter { $0.success }
        
        return Float(success.count) / Float(trials.count)
    }
    
    // MARK: - Codable
    
    enum CodingKeys: CodingKey {
        case trials, successRate
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(trials, forKey: .trials)
        try container.encode(successRate, forKey: .successRate)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        trials = try container.decode([T].self, forKey: .trials)
    }
    
    init() {}
}

final class ScrollTask: Task<ScrollTrial> {
    var isHorizontal: Bool = false
    
    convenience init(horizontal: Bool) {
        self.init()
        self.isHorizontal = horizontal
    }
}
