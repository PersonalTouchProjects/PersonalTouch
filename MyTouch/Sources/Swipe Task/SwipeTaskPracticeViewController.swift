//
//  SwipeTaskPracticeViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/18.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class SwipeTaskPracticeViewController: TaskTrialViewController {
    
    let swipeTrialView = SwipeTrialView()
    
    override func nextViewController() -> TaskViewController {
        return SwipeTaskTrialViewController()
    }
    
    override func trialView() -> (UIView & TrialViewProtocol) {
        return swipeTrialView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipeTrialView.dataSource = self
    }
    
    override func didEndTrial() {
        super.didEndTrial()
        
        swipeTrialView.reloadData()
    }
    
    private var lastPracticeDirection: SwipeTrial.Direction?
}

extension SwipeTaskPracticeViewController: SwipeTrialViewDataSource {
    
    func swipeArea(_ swipeTrialView: SwipeTrialView) -> SwipeTrialView.SwipeArea {
        return [.left, .right].shuffled().first!
    }
    
    func direction(_ swipeTrialView: SwipeTrialView) -> SwipeTrial.Direction {
        
        var directions: Set<SwipeTrial.Direction> = [
            .right, .upRight, .up, .upLeft,
            .left, .downLeft, .down, .downRight
        ]
        
        if let last = lastPracticeDirection {
            directions.remove(last)
        }
        
        lastPracticeDirection = directions.shuffled().first!
        return lastPracticeDirection!
    }
}
