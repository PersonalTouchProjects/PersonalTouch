//
//  DragAndDropTrialViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/18.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class DragAndDropTaskTrialViewController: TaskTrialViewController<DragAndDropTrial> {
    
    let dragAndDropTrialView = DragAndDropTrialView()
    
    var numberOfRepeats = 1
    var positions: [(DragAndDropTrialView.Distance, DragAndDropTrialView.Direction)] = [] {
        didSet { updateNextButton() }
    }
    
    override func nextViewController() -> TaskViewController<DragAndDropTrial>? {
        return TaskEndViewController()
    }
    
    override func trialView() -> (UIView & TrialViewProtocol) {
        return dragAndDropTrialView
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
        
        positions = positionGenerator(repeats: 1).shuffled()
        
        dragAndDropTrialView.dataSource = self
    }
    
    override func didEndTrial() {
        super.didEndTrial()
        
        // handle trial result
        var dragTrial = DragAndDropTrial(initialFrame: dragAndDropTrialView.initialFrame, targetFrame: dragAndDropTrialView.destinationView.frame)
        dragTrial.resultFrame = dragAndDropTrialView.targetView.frame
        dragTrial.startTime = trialStartDate.timeIntervalSince1970
        dragTrial.endTime = trialEndDate.timeIntervalSince1970
        dragTrial.rawTouchTracks = dragAndDropTrialView.rawTracks
        dragTrial.success = dragAndDropTrialView.destinationView.frame.contains(dragAndDropTrialView.targetView.center) // TODO: define success
        dragTrial.allEvents = dragAndDropTrialView.gestureRecognizerEvents
        
        task?.trials.append(dragTrial)
        // end of add new trial
        
        positions.removeFirst()
        
        if !positions.isEmpty {
            dragAndDropTrialView.reloadData()
            instructionLabel.text = NSLocalizedString("Tap Task Title", comment: "") + " (25 之 \(25 - positions.count + 1))"
        } else {
            presentNext()
        }
    }
}

extension DragAndDropTaskTrialViewController: DragAndDropTrialViewDataSource {
    
    func direction(_ dragAndDropTrialView: DragAndDropTrialView) -> DragAndDropTrialView.Direction {
        return positions.first!.1
    }
    
    func distance(_ dragAndDropTrialView: DragAndDropTrialView) -> DragAndDropTrialView.Distance {
        return positions.first!.0
    }
    
    func targetSize(_ dragAndDropTrialView: DragAndDropTrialView) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}

private func positionGenerator(repeats: Int) -> [(DragAndDropTrialView.Distance, DragAndDropTrialView.Direction)] {
    return [.short, .long].flatMap { distance in
        return [.right, .upRight, .up, .upLeft, .left, .downLeft, .down, .downRight].map { direction in (distance, direction) }
    }
}
