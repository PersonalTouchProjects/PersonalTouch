//
//  PinchTaskTrialViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/20.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class PinchTaskTrialViewController: TaskTrialViewController {
    
    let pinchTrialView = PinchTrialView()
    
    var numberOfRepeats = 1
    var scales: [CGFloat] = []
    
    override func nextViewController() -> TaskViewController? {
        return TaskEndViewController()
    }
    
    override func trialView() -> (UIView & TrialViewProtocol) {
        return pinchTrialView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scales = scaleGenerator(repeats: numberOfRepeats)
        
        pinchTrialView.dataSource = self
    }
    
    override func didEndTrial() {
        super.didEndTrial()
        
        
        // handle trial result
        var trial = PinchTrial(initialSize: pinchTrialView.initialFrame.size, targetSize: pinchTrialView.destinationView.frame.size)
        trial.resultSize = pinchTrialView.targetView.frame.size
        trial.startTime = trialStartDate.timeIntervalSince1970
        trial.endTime = trialEndDate.timeIntervalSince1970
        trial.rawTouchTracks = pinchTrialView.rawTracks
        trial.success = pinchTrialView.success
        trial.allEvents = pinchTrialView.gestureRecognizerEvents
        
        taskResultManager?.addTrial(trial)
        // end of add new trial
        
        scales.removeFirst()
        
        if scales.isEmpty {
            
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
            pinchTrialView.reloadData()
            instructionLabel.text = NSLocalizedString("Tap Task Title", comment: "") + " (25 之 \(25 - scales.count + 1))"
        }
    }
}

extension PinchTaskTrialViewController: PinchTrialViewDataSource {
    
    func targetScale(_ pinchTrialView: PinchTrialView) -> CGFloat {
        return scales.first!
    }
}

private func scaleGenerator(repeats: Int) -> [CGFloat] {
    return (0..<repeats).flatMap { _ in [1.0/2.0, 2.0/3.0, 3.0/2.0, 2.0] }
}
