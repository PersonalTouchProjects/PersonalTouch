//
//  LongPressTaskPracticeViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/8/10.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class LongPressTaskPracticeViewController: TaskTrialViewController<LongPressTrial> {
    
    let longPressTrialView = LongPressTrialView()
    
    override func nextViewController() -> TaskViewController<LongPressTrial>? {
        return LongPressTaskTrialViewController()
    }
    
    override func presentNextConfirmTitle() -> String? {
        return "Start Trials?"
    }
    
    override func trialView() -> (UIView & TrialViewProtocol) {
        return longPressTrialView
    }
    
    override func instructionText() -> String {
        return """
        按下練習按鈕開始練習，十字會出現在空白畫面中的任意位置，請用一隻手指點擊一次十字。
        按下下一步正式開始測驗。
        """
    }
    
    override func actionTitle() -> String {
        return "練習"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "點擊測驗練習"
        
        longPressTrialView.dataSource = self
    }
    
    override func didEndTrial() {
        super.didEndTrial()
        
        longPressTrialView.reloadData()
    }
}

extension LongPressTaskPracticeViewController: LongPressTrialViewDataSource {
    
    func numberOfColumn(_ tapTrialView: LongPressTrialView) -> Int {
        return 3
    }
    
    func numberOfRow(_ tapTrialView: LongPressTrialView) -> Int {
        return 3
    }
    
    func targetColumn(_ tapTrialView: LongPressTrialView) -> Int {
        return Int(arc4random() % 3)
    }
    
    func targetRow(_ tapTrialView: LongPressTrialView) -> Int {
        return Int(arc4random() % 3)
    }
    
    func targetSize(_ tapTrialView: LongPressTrialView) -> CGSize {
        return CGSize(width: 44, height: 44)
    }
}
