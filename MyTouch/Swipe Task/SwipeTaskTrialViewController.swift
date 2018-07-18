//
//  SwipeTaskTrialViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/18.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class SwipeTaskTrialViewController: TaskTrialViewController {
    
    let swipeTrialView = SwipeTrialView()
    
    var numberOfRepeats = 1
    var directions: [(SwipeTrialView.SwipeArea, SwipeTrial.Direction)] = []
    
    override func nextViewController() -> (UIViewController & TaskResultManagerViewController)? {
        return TaskEndViewController()
    }
    
    override func loadView() {
        super.loadView()
        self.trialView = swipeTrialView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        directions = directionGenerator(repeats: 1).shuffled()
        
        swipeTrialView.delegate = self
        swipeTrialView.dataSource = self
    }
    
    override func didEndTrial() {
        super.didEndTrial()
        
        // handle trial result
        let areaFrame = swipeTrialView.areaView.frame
        let targetDirection = directions.first!.1
        
        var swipeTrial = SwipeTrial(areaFrame: areaFrame, targetDirection: targetDirection)
        swipeTrial.startTime = trialStartDate.timeIntervalSince1970
        swipeTrial.endTime = trialStartDate.timeIntervalSince1970
        swipeTrial.rawTouchTracks = swipeTrialView.rawTracks
        swipeTrial.success = targetDirection == swipeTrialView.recognizedDirection
        swipeTrial.addEvents(swipeTrialView.gestureRecognizerEvents)
        
        
        taskResultManager?.addTrial(swipeTrial)
        // end of add new trial
        
        directions.removeFirst()
        
        if directions.isEmpty {
            
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
            swipeTrialView.reloadData()
            titleLabel.text = NSLocalizedString("Tap Task Title", comment: "") + " (25 之 \(25 - directions.count + 1))"
        }
    }
}

extension SwipeTaskTrialViewController: SwipeTrialViewDataSource {
    
    func swipeArea(_ swipeTrialView: SwipeTrialView) -> SwipeTrialView.SwipeArea {
        return directions.first!.0
    }
    
    func direction(_ swipeTrialView: SwipeTrialView) -> SwipeTrial.Direction {
        return directions.first!.1
    }
}

func directionGenerator(repeats: Int) -> [(SwipeTrialView.SwipeArea, SwipeTrial.Direction)] {
    
//    return [(.left, .left)]
    
    return (0..<repeats).flatMap { _ in
        return [.left, .right].flatMap { area in
            return [.right, .upRight, .up, .upLeft, .left, .downLeft, .down, .downRight].map { direction in (area, direction) }
        }
    }
}
