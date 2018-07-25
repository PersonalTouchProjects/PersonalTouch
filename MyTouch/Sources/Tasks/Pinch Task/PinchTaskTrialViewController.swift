//
//  PinchTaskTrialViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/20.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class PinchTaskTrialViewController: TaskTrialViewController<PinchTrial> {
    
    let pinchTrialView = PinchTrialView()
    
    var numberOfRepeats = 2
    var scales: [CGFloat] = [] {
        didSet { updateNextButton() }
    }
    
    private var totalTrialsCount: Int = 0
    
    override func nextViewController() -> TaskViewController<PinchTrial>? {
        return TaskEndViewController()
    }
    
    override func trialView() -> (UIView & TrialViewProtocol) {
        return pinchTrialView
    }
    
    override func prefersNextButtonEnabled() -> Bool {
        return scales.isEmpty
    }
    
    override func dismissConfirmTitle() -> String? {
        return "Are you sure?"
    }
    
    override func dismissConfirmMessage() -> String? {
        return "Data will be deleted."
    }
    
    override func instructionText() -> String {
        return """
        按下開始按鈕開始測驗，請將矩形放大或縮小至目標大小。
        """
    }
    
    override func actionTitle() -> String {
        return "開始"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scales = scaleGenerator(repeats: numberOfRepeats)
        totalTrialsCount = scales.count
        
        title = "縮放測驗 1/\(totalTrialsCount)"
        navigationItem.rightBarButtonItem?.title = "1/\(totalTrialsCount)"
        
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
        
        task?.trials.append(trial)
        // end of add new trial
        
        scales.removeFirst()
        
        if !scales.isEmpty {
            pinchTrialView.reloadData()
            title = "縮放測驗 \(totalTrialsCount - scales.count + 1)/\(totalTrialsCount)"
            navigationItem.rightBarButtonItem?.title = "\(totalTrialsCount - scales.count + 1)/\(totalTrialsCount)"
        } else {
            presentNext()
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
