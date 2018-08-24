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
        按下練習按鈕開始練習，請將列表中的目標項目（藍色）滾動至畫面中。
        按下下一步正式開始測驗。
        """
    }
    
    override func actionTitle() -> String {
        return "練習"
    }
    
    override func timeIntervalBeforeEndTrial() -> TimeInterval {
        return scrollTrialView.timeIntervalBeforeStopDecelarating + 1
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
        return 200
    }
    
    func initialItem(_ scrollTrialView: ScrollTrialView) -> Int {
        return 100
    }
    
    func targetItem(_ scrollTrialView: ScrollTrialView) -> Int {
        return 100 + [-5, -3, 3, 5].shuffled().first!
    }
    
    func axis(_ scrollTrialView: ScrollTrialView) -> ScrollTrial.Axis {
        return axis
    }
}
