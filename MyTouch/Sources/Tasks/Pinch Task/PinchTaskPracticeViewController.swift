//
//  PinchTaskPracticeViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/20.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class PinchTaskPracticeViewController: TaskTrialViewController<PinchTrial> {
    
    let pinchTrialView = PinchTrialView()
    
    override func nextViewController() -> TaskViewController<PinchTrial>? {
        return PinchTaskTrialViewController()
    }
    
    override func presentNextConfirmTitle() -> String? {
        return "Start Trials?"
    }
    
    override func instructionText() -> String {
        return """
        按下練習按鈕開始練習，請將矩形放大或縮小至目標大小。
        按下下一步正式開始測驗。
        """
    }
    
    override func actionTitle() -> String {
        return "練習"
    }
    
    override func trialView() -> (UIView & TrialViewProtocol) {
        return pinchTrialView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "縮放測驗練習"
        
        pinchTrialView.dataSource = self
    }
    
    override func didEndTrial() {
        super.didEndTrial()

        pinchTrialView.reloadData()
    }
}

extension PinchTaskPracticeViewController: PinchTrialViewDataSource {
    
    func targetScale(_ pinchTrialView: PinchTrialView) -> CGFloat {
        let scales: [CGFloat] = [1/2, 2/3, 3/2, 2]
        return scales.shuffled().first!
    }
}
