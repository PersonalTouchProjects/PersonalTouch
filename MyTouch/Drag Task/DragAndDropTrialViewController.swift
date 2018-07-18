//
//  DragAndDropTrialViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/18.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class DragAndDropTaskTrialViewController: TaskTrialViewController {
    
    let dragAndDropTrialView = DragAndDropTrialView()
    
    var numberOfRepeats = 1
    var positions: [(DragAndDropTrialView.Distance, DragAndDropTrialView.Direction)] = []
    
    override func nextViewController() -> (UIViewController & TaskResultManagerViewController)? {
        return TaskEndViewController()
    }
    
    override var countdownColor: UIColor {
        return .white
    }
    
    override func loadView() {
        super.loadView()
        self.trialView = dragAndDropTrialView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        positions = positionGenerator(repeats: 1).shuffled()
        
        dragAndDropTrialView.delegate = self
        dragAndDropTrialView.dataSource = self
    }
    
    override func didEndTrial() {
        super.didEndTrial()
        
        // handle trial result
//        let areaFrame = dragAndDropTrialView.areaView.frame
//        let targetDirection = directions.first!.1
//
//        var swipeTrial = SwipeTrial(areaFrame: areaFrame, targetDirection: targetDirection)
//        swipeTrial.startTime = trialStartDate.timeIntervalSince1970
//        swipeTrial.endTime = trialStartDate.timeIntervalSince1970
//        swipeTrial.rawTouchTracks = dragAndDropTrialView.rawTracks
//        swipeTrial.success = targetDirection == dragAndDropTrialView.recognizedDirection
//        swipeTrial.addEvents(dragAndDropTrialView.gestureRecognizerEvents)
//
//
//        taskResultManager?.addTrial(swipeTrial)
        // end of add new trial
        
        positions.removeFirst()
        
        if positions.isEmpty {
            
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
            dragAndDropTrialView.reloadData()
            titleLabel.text = NSLocalizedString("Tap Task Title", comment: "") + " (25 之 \(25 - positions.count + 1))"
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

func positionGenerator(repeats: Int) -> [(DragAndDropTrialView.Distance, DragAndDropTrialView.Direction)] {
    return [.short, .long].flatMap { distance in
        return [.right, .upRight, .up, .upLeft, .left, .downLeft, .down, .downRight].map { direction in (distance, direction) }
    }
}
