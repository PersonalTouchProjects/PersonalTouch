//
//  ScrollTrialViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/19.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class ScrollTaskTrialViewController: TaskTrialViewController {
    
    let scrollTrialView = ScrollTrialView()
    
    var axis = ScrollTrial.Axis.horizontal
    var rows = 5
    var targetRow = 2
    var numberOfRepeats = 1
    var positions: [Int] = [] {
        didSet { updateNextButton() }
    }
    
    override func nextViewController() -> TaskViewController? {
        return TaskEndViewController()
    }
    
    override func trialView() -> (UIView & TrialViewProtocol) {
        return scrollTrialView
    }
    
    override func prefersNextButtonEnabled() -> Bool {
        return positions.isEmpty
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
//        var dragTrial = DragAndDropTrial(initialFrame: scrollTrialView.initialFrame, targetFrame: scrollTrialView.destinationView.frame)
//        dragTrial.resultFrame = scrollTrialView.targetView.frame
//        dragTrial.startTime = trialStartDate.timeIntervalSince1970
//        dragTrial.endTime = trialEndDate.timeIntervalSince1970
//        dragTrial.rawTouchTracks = scrollTrialView.rawTracks
//        dragTrial.success = scrollTrialView.destinationView.frame.contains(scrollTrialView.targetView.center) // TODO: define success
//        dragTrial.addEvents(scrollTrialView.gestureRecognizerEvents)
//
//        taskResultManager?.addTrial(dragTrial)
        // end of add new trial
        
        positions.removeFirst()
        
        if !positions.isEmpty  {
            scrollTrialView.reloadData()
            instructionLabel.text = NSLocalizedString("Tap Task Title", comment: "") + " (25 之 \(25 - positions.count + 1))"
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
    return (0..<repeats).flatMap { _ in (0..<rows).compactMap { ($0 == targetRow) ? nil : $0 } }
}
