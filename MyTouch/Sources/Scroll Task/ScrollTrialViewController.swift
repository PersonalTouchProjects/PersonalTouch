//
//  ScrollTrialViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/19.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class ScrollTaskTrialViewController: TaskTrialViewController<ScrollTrial> {
    
    let scrollTrialView = ScrollTrialView()
    
    var axis = ScrollTrial.Axis.vertical
    var rows = 5
    var targetRow = 2
    var numberOfRepeats = 1
    var positions: [Int] = [] {
        didSet { updateNextButton() }
    }
    
    override func nextViewController() -> TaskViewController<ScrollTrial>? {
        return TaskEndViewController()
    }
    
    override func trialView() -> (UIView & TrialViewProtocol) {
        return scrollTrialView
    }
    
    override func prefersNextButtonEnabled() -> Bool {
        return positions.isEmpty
    }
    
    override func dismissConfirmTitle() -> String? {
        return "Are you sure?"
    }
    
    override func dismissConfirmMessage() -> String? {
        return "Data will be deleted."
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        positions = positionGenerator(rows: rows, targetRow: targetRow, repeats: numberOfRepeats).shuffled()
        
        scrollTrialView.scrollView.isScrollEnabled = false
        scrollTrialView.dataSource = self
    }
    
    override func didStartTrial() {
        super.didStartTrial()
        scrollTrialView.scrollView.isScrollEnabled = true
    }
    
    override func didEndTrial() {
        super.didEndTrial()
        
        scrollTrialView.scrollView.isScrollEnabled = false
        
        // handle trial result
        var trial = ScrollTrial(axis: axis, initialPosition: scrollTrialView.initialPosition, targetPosition: scrollTrialView.destinationPosition)
        trial.endDraggingPosition = scrollTrialView.touchUpPosition
        trial.predictedPosition = scrollTrialView.predictedPosition
        
        trial.startTime = trialStartDate.timeIntervalSince1970
        trial.endTime = trialEndDate.timeIntervalSince1970
        trial.rawTouchTracks = scrollTrialView.rawTracks
        trial.success = scrollTrialView.success
        trial.allEvents = scrollTrialView.gestureRecognizerEvents
        
        task?.trials.append(trial)
        // end of add new trial
        
        positions.removeFirst()
        
        if !positions.isEmpty  {
            scrollTrialView.reloadData()
            instructionLabel.text = NSLocalizedString("Tap Task Title", comment: "") + " (25 之 \(25 - positions.count + 1))"
        } else {
            presentNext()
        }
    }
}

extension ScrollTaskTrialViewController: ScrollTrialViewDataSource {
    
    func numberOfRows(_ scrollTrialView: ScrollTrialView) -> Int {
        return rows
    }
    
    func targetRow(_ scrollTrialView: ScrollTrialView) -> Int {
        return positions.first!
    }
    
    func destinationRow(_ scrollTrialView: ScrollTrialView) -> Int {
        return targetRow
    }
    
    func axis(_ scrollTrialView: ScrollTrialView) -> ScrollTrial.Axis {
        return axis
    }
}

private func positionGenerator(rows: Int, targetRow: Int, repeats: Int) -> [Int] {
    return [1]
    return (0..<repeats).flatMap { _ in (0..<rows).compactMap { ($0 == targetRow) ? nil : $0 } }
}
