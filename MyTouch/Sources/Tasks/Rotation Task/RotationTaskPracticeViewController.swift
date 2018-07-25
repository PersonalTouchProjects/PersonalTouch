//
//  RotationTaskPracticeViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/20.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class RotationTaskPracticeViewController: TaskTrialViewController<RotationTrial> {
    
    let rotationTrialView = RotationTrialView()
    
    override func nextViewController() -> TaskViewController<RotationTrial>? {
        return RotationTaskTrialViewController()
    }
    
    override func presentNextConfirmTitle() -> String? {
        return "Start Trials?"
    }
    
    override func instructionText() -> String {
        return """
        按下練習按鈕開始練習，請將指北針旋轉至指向正北。
        按下下一步正式開始測驗。
        """
    }
    
    override func actionTitle() -> String {
        return "練習"
    }
    
    override func trialView() -> (UIView & TrialViewProtocol) {
        return rotationTrialView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "旋轉測驗練習"
        
        countDownView.label.textColor = UIColor(red:0.28, green:0.54, blue:0.95, alpha:1.00)
        rotationTrialView.dataSource = self
    }
    
    override func didEndTrial() {
        super.didEndTrial()
        
        rotationTrialView.reloadData()
    }
}

extension RotationTaskPracticeViewController: RotationTrialViewDataSource {
    
    func targetAngle(_ rotationTrialView: RotationTrialView) -> CGFloat {
        let angles: [CGFloat] = [
            -.pi / 3,
            -.pi / 6,
            .pi / 6,
            .pi / 3
        ]
        return angles.shuffled().first!
    }
}
