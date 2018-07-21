//
//  PinchTaskPracticeViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/20.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class PinchTaskPracticeViewController: TaskTrialViewController {
    
    let pinchTrialView = PinchTrialView()
    
    override func nextViewController() -> TaskViewController {
        return PinchTaskTrialViewController()
    }
    
    override func presentNextConfirmTitle() -> String? {
        return "Start Trials?"
    }
    
    override func trialView() -> (UIView & TrialViewProtocol) {
        return pinchTrialView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
