//
//  DragAndDropTrialViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/18.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class DragAndDropTaskPracticeViewController: TaskTrialViewController {
    
    let dragAndDropTrialView = DragAndDropTrialView()
    
    var shouldStartTrial = false
    
    override func nextViewController() -> TaskViewController {
        return DragAndDropTaskTrialViewController()
    }
    
    override var shouldStartTrialAutomaticallyOnPrimaryButtonTapped: Bool {
        return false
    }
    
    override func loadView() {
        super.loadView()
        self.trialView = dragAndDropTrialView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dragAndDropTrialView.touchTrackingDelegate = self
        dragAndDropTrialView.dataSource = self
        
        primaryButton.setTitle("Practice", for: .normal)
        secondaryButton.setTitle("Skip", for: .normal)
        
        secondaryButton.isHidden = false
    }
    
    override func didEndTrial() {
        super.didEndTrial()
        
        dragAndDropTrialView.reloadData()
        
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
    
    private var lastPracticeDirection: DragAndDropTrialView.Direction?
}

extension DragAndDropTaskPracticeViewController: DragAndDropTrialViewDataSource {
    
    func direction(_ dragAndDropTrialView: DragAndDropTrialView) -> DragAndDropTrialView.Direction {
        
        var directions: Set<DragAndDropTrialView.Direction> = [
            .right, .upRight, .up, .upLeft,
            .left, .downLeft, .down, .downRight
        ]
        
        if let last = lastPracticeDirection {
            directions.remove(last)
        }
        
        lastPracticeDirection = directions.shuffled().first!
        return lastPracticeDirection!
    }
    
    func distance(_ dragAndDropTrialView: DragAndDropTrialView) -> DragAndDropTrialView.Distance {
        return [.short, .long].shuffled().first!
    }
    
    func targetSize(_ dragAndDropTrialView: DragAndDropTrialView) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
}
