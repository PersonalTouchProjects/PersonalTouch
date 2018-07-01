//
//  TapTaskTrialViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/1.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TapTaskTrialViewController: TaskTrialViewController {

    let tapTrialView = TapPracticeView()
    let countDownView = CountdownView()
    
    var isTrialEnded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tapTrialView.isVisualLogEnabled = true
        tapTrialView.delegate = self
        
        self.trialView = tapTrialView
        
        view.addSubview(countDownView)
        countDownView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            countDownView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countDownView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            countDownView.widthAnchor.constraint(equalToConstant: 100),
            countDownView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        actionButton.isHidden = true
        cancelButton.isHidden = true
        countDownView.fire {
            self.startTrial()
        }
    }
    
    override func actionButtonDidSelect() {
        super.actionButtonDidSelect()
        
        if isTrialEnded {
            let endViewController = TapTaskEndViewController()
            navigationController?.pushViewController(endViewController, animated: false)
        } else {
            startTrial()
        }
    }
    
    override func cancelButtonDidSelect() {
        super.cancelButtonDidSelect()

        dismiss(animated: true, completion: nil)
    }
}

extension TapTaskTrialViewController: TouchTrackingViewDelegate {
    
    func touchTrackingViewDidEndTracking(_ touchTrackingView: TouchTrackingView) {
        isTrialEnded = true
        endTrial()
        actionButton.isHidden = false
        cancelButton.isHidden = false
    }
}
