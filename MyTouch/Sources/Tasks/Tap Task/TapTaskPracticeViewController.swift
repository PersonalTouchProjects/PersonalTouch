//
//  TapTaskPracticeViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/8.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TapTaskPracticeViewController: TaskTrialViewController<TapTrial> {

    let tapTrialView = TapTrialView()
    
    override func nextViewController() -> TaskViewController<TapTrial>? {
        return TapTaskTrialViewController()
    }
    
    override func presentNextConfirmTitle() -> String? {
        return "Start Trials?"
    }
    
    override func trialView() -> (UIView & TrialViewProtocol) {
        return tapTrialView
    }
    
    override func instructionText() -> String {
        return """
        按下練習按鈕開始練習，方框會出現在空白畫面中的任意位置，請用一隻手指點擊一次方框。
        按下下一步正式開始測驗。
        """
    }
    
    override func actionTitle() -> String {
        return "練習"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "點擊測驗練習"
        
        tapTrialView.dataSource = self
    }
    
    override func didEndTrial() {
        super.didEndTrial()
        
        tapTrialView.reloadData()
    }
}

extension TapTaskPracticeViewController: TapTrialViewDataSource {
    
    func numberOfColumn(_ tapTrialView: TapTrialView) -> Int {
        return 5
    }
    
    func numberOfRow(_ tapTrialView: TapTrialView) -> Int {
        return 5
    }
    
    func targetColumn(_ tapTrialView: TapTrialView) -> Int {
        return Int(arc4random() % 5)
    }
    
    func targetRow(_ tapTrialView: TapTrialView) -> Int {
        return Int(arc4random() % 5)
    }
    
    func targetSize(_ tapTrialView: TapTrialView) -> CGSize {
        return CGSize(width: 76, height: 76)
    }
}
