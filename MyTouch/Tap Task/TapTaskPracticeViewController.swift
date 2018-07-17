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
    
    var shouldStartTrial = false
    
    override func nextViewController() -> (UIViewController & TaskResultManagerViewController) {
        return TapTaskTrialViewController()
    }
    
    override var shouldStartTrialAutomaticallyOnPrimaryButtonTapped: Bool {
        return false
    }
    
    override func loadView() {
        super.loadView()
        self.trialView = tapTrialView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapTrialView.delegate = self
        tapTrialView.dataSource = self
        
        primaryButton.setTitle("Practice", for: .normal)
        secondaryButton.setTitle("Skip", for: .normal)
        
        secondaryButton.isHidden = false
    }
    
    override func didEndTrial() {
        super.didEndTrial()
        
        tapTrialView.reloadData()
        
        shouldStartTrial = true
        
        UIView.performWithoutAnimation {
            self.primaryButton.setTitle("End Practice", for: .normal)
            self.secondaryButton.setTitle("Try Again", for: .normal)
        }
    }
    
    override func primaryButtonDidSelect() {
        super.primaryButtonDidSelect()
        
        if shouldStartTrial {
            presentStartTrialAlert()
        } else {
            startTrial()
        }
    }
    
    override func secondaryButtonDidSelect() {
        super.secondaryButtonDidSelect()
        
        if shouldStartTrial {
            startTrial()
        } else {
            presentStartTrialAlert()
        }
    }
    
    private func presentStartTrialAlert() {
        
        let alertController = UIAlertController(title: "Start Trial", message: "Are you sure?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let confirmAction = UIAlertAction(title: "Go", style: .default) { (action) in
            self.presentNextViewController()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        alertController.preferredAction = confirmAction
        
        present(alertController, animated: true, completion: nil)
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
