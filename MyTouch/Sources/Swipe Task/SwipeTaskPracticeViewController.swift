//
//  SwipeTaskPracticeViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/18.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class SwipeTaskPracticeViewController: TaskTrialViewController {
    
    let swipeTrialView = SwipeTrialView()
    
    var shouldStartTrial = false
    
    override func nextViewController() -> (UIViewController & TaskResultManagerViewController) {
        return SwipeTaskTrialViewController()
    }
    
    override var shouldStartTrialAutomaticallyOnPrimaryButtonTapped: Bool {
        return false
    }
    
    override var countdownColor: UIColor {
        return .white
    }
    
    override func loadView() {
        super.loadView()
        self.trialView = swipeTrialView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipeTrialView.touchTrackingDelegate = self
        swipeTrialView.dataSource = self
        
        primaryButton.setTitle("Practice", for: .normal)
        secondaryButton.setTitle("Skip", for: .normal)
        
        secondaryButton.isHidden = false
    }
    
    override func didEndTrial() {
        super.didEndTrial()
        
        swipeTrialView.reloadData()
        
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
    
    private var lastPracticeDirection: SwipeTrial.Direction?
}

extension SwipeTaskPracticeViewController: SwipeTrialViewDataSource {
    
    func swipeArea(_ swipeTrialView: SwipeTrialView) -> SwipeTrialView.SwipeArea {
        return [.left, .right].shuffled().first!
    }
    
    func direction(_ swipeTrialView: SwipeTrialView) -> SwipeTrial.Direction {
        
        var directions: Set<SwipeTrial.Direction> = [
            .right, .upRight, .up, .upLeft,
            .left, .downLeft, .down, .downRight
        ]
        
        if let last = lastPracticeDirection {
            directions.remove(last)
        }
        
        lastPracticeDirection = directions.shuffled().first!
        return lastPracticeDirection!
    }
}
