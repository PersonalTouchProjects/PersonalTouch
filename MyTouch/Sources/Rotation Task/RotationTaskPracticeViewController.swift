//
//  RotationTaskPracticeViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/20.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class RotationTaskPracticeViewController: TaskTrialViewController {
    
    let rotationTrialView = RotationTrialView()
    
    override func nextViewController() -> TaskViewController {
        return RotationTaskTrialViewController()
    }
    
    override func trialView() -> (UIView & TrialViewProtocol) {
        return rotationTrialView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
