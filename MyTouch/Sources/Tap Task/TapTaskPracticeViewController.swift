//
//  TapTaskPracticeViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/8.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TapTaskPracticeViewController: TaskTrialViewController {

    let tapTrialView = TapTrialView()
    
    private var practiced = false
    
    override func prefersNextButtonEnabled() -> Bool {
        return practiced
    }
    
    override func nextViewController() -> TaskViewController? {
        return TapTaskTrialViewController()
    }
    
    override func trialView() -> (UIView & TrialViewProtocol) {
        return tapTrialView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapTrialView.dataSource = self
    }
    
    override func willEndTrial() {
        super.willEndTrial()
        
        practiced = true
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
        return CGSize(width: 80, height: 80)
    }
}
