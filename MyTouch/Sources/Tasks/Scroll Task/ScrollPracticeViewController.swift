//
//  ScrollPracticeViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/19.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class ScrollTaskPracticeViewController: TaskTrialViewController<ScrollTrial> {
    
    let scrollTrialView = ScrollTrialView(frame: .zero)
    
    override func nextViewController() -> TaskViewController<ScrollTrial>? {
        let vc = ScrollTaskTrialViewController()
        vc.axis = axis
        return vc
    }
    
    override func presentNextConfirmTitle() -> String? {
        return "Start Trials?"
    }
    
    override func trialView() -> (UIView & TrialViewProtocol) {
        return scrollTrialView
    }
    
    override func instructionText() -> String {
        return """
        按下練習按鈕開始練習，請將藍色矩形滾動至目標區域。
        按下下一步正式開始測驗。
        """
    }
    
    override func actionTitle() -> String {
        return "練習"
    }
    
    var axis = ScrollTrial.Axis.vertical
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "滾動測驗練習"
        
        scrollTrialView.isScrollEnabled = false
        scrollTrialView.trialDataSource = self
        
        countDownView.label.textColor = .white
    }
    
    override func didStartTrial() {
        super.didStartTrial()
        
        scrollTrialView.isScrollEnabled = true
    }
    
    override func didEndTrial() {
        super.didEndTrial()
        
        scrollTrialView.isScrollEnabled = false
        scrollTrialView.reloadData()
    }
}

extension ScrollTaskPracticeViewController: ScrollTrialViewDataSource {
    
    func numberOfItems(_ scrollTrialView: ScrollTrialView) -> Int {
        return 100
    }
    
    func initialItem(_ scrollTrialView: ScrollTrialView) -> Int {
        return 50
    }
    
    func targetItem(_ scrollTrialView: ScrollTrialView) -> Int {
        return 40
    }
    
    func axis(_ scrollTrialView: ScrollTrialView) -> ScrollTrial.Axis {
        return axis
    }
}
