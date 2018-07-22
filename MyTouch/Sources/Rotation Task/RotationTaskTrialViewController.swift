//
//  RotationTaskTrialViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/20.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class RotationTaskTrialViewController: TaskTrialViewController<RotationTrial> {
    
    let rotationTrialView = RotationTrialView()
    
    var numberOfRepeats = 1
    var angles: [CGFloat] = [] {
        didSet { updateNextButton() }
    }
    
    override func nextViewController() -> TaskViewController<RotationTrial>? {
        return TaskEndViewController()
    }
    
    override func trialView() -> (UIView & TrialViewProtocol) {
        return rotationTrialView
    }
    
    override func prefersNextButtonEnabled() -> Bool {
        return angles.isEmpty
    }
    
    override func dismissConfirmTitle() -> String? {
        return "Are you sure?"
    }
    
    override func dismissConfirmMessage() -> String? {
        return "Data will be deleted."
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        angles = angleGenerator(repeats: numberOfRepeats).shuffled()
        
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
        trial.allEvents = rotationTrialView.gestureRecognizerEvents
        
        task?.trials.append(trial)
//        taskResultManager?.addTrial(trial)
        // end of add new trial
        
        angles.removeFirst()
        
        if !angles.isEmpty {
            rotationTrialView.reloadData()
            instructionLabel.text = NSLocalizedString("Tap Task Title", comment: "") + " (25 之 \(25 - angles.count + 1))"
        } else {
            presentNext()
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
