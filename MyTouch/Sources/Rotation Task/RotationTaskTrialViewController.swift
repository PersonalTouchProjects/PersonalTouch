//
//  RotationTaskTrialViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/20.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class RotationTaskTrialViewController: TaskTrialViewController {
    
    let rotationTrialView = RotationTrialView()
    
    var numberOfRepeats = 1
    var angles: [CGFloat] = []
    
    override func nextViewController() -> (UIViewController & TaskResultManagerViewController)? {
        return TaskEndViewController()
    }
    
    override func loadView() {
        super.loadView()
        self.trialView = rotationTrialView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        angles = angleGenerator(repeats: numberOfRepeats).shuffled()
        
        rotationTrialView.touchTrackingDelegate = self
        rotationTrialView.dataSource = self
    }
    
    override func didEndTrial() {
        super.didEndTrial()
        
        
        // handle trial result
        var trial = RotationTrial(initialAngle: rotationTrialView.initialAngle, targetAngle: 0)
        trial.resultAngle = rotationTrialView.compassView.transform.rotation
        trial.startTime = trialStartDate.timeIntervalSince1970
        trial.endTime = trialEndDate.timeIntervalSince1970
        trial.rawTouchTracks = rotationTrialView.rawTracks
        trial.success = rotationTrialView.success
        trial.addEvents(rotationTrialView.gestureRecognizerEvents)
        
        taskResultManager?.addTrial(trial)
        // end of add new trial
        
        angles.removeFirst()
        
        if angles.isEmpty {
            
            let alertController = UIAlertController(title: "You're done!", message: "Go away.", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "OK", style: .destructive) { (action) in
                
                if let taskViewController = self.nextViewController() {
                    taskViewController.taskResultManager = self.taskResultManager
                    self.navigationController?.pushViewController(taskViewController, animated: true)
                }
            }
            
            alertController.addAction(confirmAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            rotationTrialView.reloadData()
            titleLabel.text = NSLocalizedString("Tap Task Title", comment: "") + " (25 之 \(25 - angles.count + 1))"
        }
    }
}

extension RotationTaskTrialViewController: RotationTrialViewDataSource {
    
    func targetAngle(_ rotationTrialView: RotationTrialView) -> CGFloat {
        return angles.first!
    }
}

private func angleGenerator(repeats: Int) -> [CGFloat] {
    let angles: [CGFloat] = [
        -.pi / 3,
        -.pi / 6,
        .pi / 6,
        .pi / 3
    ]
    return (0..<repeats).flatMap { _ in angles }
}
