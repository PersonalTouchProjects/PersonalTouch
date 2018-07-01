//
//  TapTaskViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/30.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TapTaskPracticeViewController: TaskPracticeViewController {

    let tapTaskPracticeView = TapPracticeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tutorialView = tapTaskPracticeView
        tapTaskPracticeView.delegate = self
    }
    
    override func actionButtonDidSelect() {
        super.actionButtonDidSelect()
        
        let trialViewController = TapTaskTrialViewController()
        navigationController?.pushViewController(trialViewController, animated: false)
    }
    
    override func cancelButtonDidSelect() {
        super.cancelButtonDidSelect()
        
        dismiss(animated: true, completion: nil)
    }
}

extension TapTaskPracticeViewController: TouchTrackingViewDelegate {
    
    func touchTrackingViewDidEndTracking(_ touchTrackingView: TouchTrackingView) {
        
        if tapTaskPracticeView.tapRecognized {
            feedbackLabel.text = "Good"
        } else {
            feedbackLabel.text = "Sad"
        }
        
        tapTaskPracticeView.isHidden = true
        feedbackLabel.isHidden = false
    }
}
