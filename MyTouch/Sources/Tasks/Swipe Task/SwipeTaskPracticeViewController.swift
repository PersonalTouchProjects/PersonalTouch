//
//  SwipeTaskPracticeViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/18.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class SwipeTaskPracticeViewController: TaskTrialViewController<SwipeTrial> {
    
    let swipeTrialView = SwipeTrialView()
    
    override func nextViewController() -> TaskViewController<SwipeTrial>? {
        return SwipeTaskTrialViewController()
    }
    
    override func presentNextConfirmTitle() -> String? {
        return "Start Trials?"
    }
    
    override func trialView() -> (UIView & TrialViewProtocol) {
        return swipeTrialView
    }
    
    override func instructionText() -> String {
        return """
        按下練習按鈕開始練習，請在畫面的左邊或右邊順著箭頭方向快速掃動。
        按下下一步正式開始測驗。
        """
    }
    
    override func actionTitle() -> String {
        return "練習"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "掃動測驗練習"
        
        swipeTrialView.dataSource = self
        countDownView.label.textColor = .white
    }
    
    override func didEndTrial() {
        super.didEndTrial()
        
        swipeTrialView.reloadData()
    }
    
    private var lastPracticeDirection: SwipeTrial.Direction?
}

extension SwipeTaskPracticeViewController: SwipeTrialViewDataSource {
    
//    func swipeArea(_ swipeTrialView: SwipeTrialView) -> SwipeTrialView.SwipeArea {
//        return [.left, .right].shuffled().first!
//    }
    
    func direction(_ swipeTrialView: SwipeTrialView) -> SwipeTrial.Direction {
        
        var directions: Set<SwipeTrial.Direction> = [
            .up, .down, .left, .right,
//            .right, .upRight, .up, .upLeft,
//            .left, .downLeft, .down, .downRight
        ]
        
        if let last = lastPracticeDirection {
            directions.remove(last)
        }
        
        lastPracticeDirection = directions.shuffled().first!
        return lastPracticeDirection!
    }
}
