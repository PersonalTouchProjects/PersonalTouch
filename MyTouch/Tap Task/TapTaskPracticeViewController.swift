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

        self.titleLabel.text = "Tap Task Practice"
        self.descriptionLabel.text = "Please tap on the blue square on the screen."
        
        self.actionButton.setTitle("Start Task (30 trials)", for: .normal)
        self.cancelButton.setTitle("Try Again", for: .normal)
        
        self.actionButton.isEnabled = false
        self.cancelButton.isEnabled = false
        
        self.practiceView = tapTaskPracticeView
        tapTaskPracticeView.delegate = self
        tapTaskPracticeView.isVisualLogEnabled = true
        
        tapTaskPracticeView.startTracking()
    }
    
    override func actionButtonDidSelect() {
        super.actionButtonDidSelect()
        
        let trialViewController = TapTaskTrialViewController()
        navigationController?.pushViewController(trialViewController, animated: false)
    }
    
    override func cancelButtonDidSelect() {
        super.cancelButtonDidSelect()
        
        tapTaskPracticeView.reset()
        tapTaskPracticeView.isHidden = false
        feedbackLabel.isHidden = true
        
        actionButton.isEnabled = false
        cancelButton.isEnabled = false
    }
}

extension TapTaskPracticeViewController: TouchTrackingViewDelegate {
    
    func touchTrackingViewDidEndTracking(_ touchTrackingView: TouchTrackingView) {
        
//        titleLabel.text = self.tapTaskPracticeView.tzuChuan.direction.rawValue
        
        if tapTaskPracticeView.tapRecognized {
            feedbackLabel.text = "Good"
        } else {
            feedbackLabel.text = "Sad"
        }

        tapTaskPracticeView.isHidden = true
        feedbackLabel.isHidden = false

        actionButton.isEnabled = true
        cancelButton.isEnabled = true
    }
    
    func touchTrackingViewDidCompleteNewTracks(_ touchTrackingView: TouchTrackingView) {
                
        if tapTaskPracticeView.tapRecognized {
            feedbackLabel.text = "Good"
        } else {
            feedbackLabel.text = "Sad"
        }
        
        tapTaskPracticeView.isHidden = true
        feedbackLabel.isHidden = false
        
        actionButton.isEnabled = true
        cancelButton.isEnabled = true
    }
}
