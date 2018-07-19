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
        self.trialView = scrollTrialView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        positions = positionGenerator(repeats: 1).shuffled()
        scrollTrialView.scrollView.isScrollEnabled = false
        scrollTrialView.touchTrackingDelegate = self
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
        
//        positions.removeFirst()
        
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
            scrollTrialView.reloadData()
            titleLabel.text = NSLocalizedString("Tap Task Title", comment: "") + " (25 之 \(25 - positions.count + 1))"
        }
    }
}

extension ScrollTaskTrialViewController: ScrollTrialViewDataSource {
    
    func numberOfRows(_ scrollTrialView: ScrollTrialView) -> Int {
        return 5
    }
    
    func targetRow(_ scrollTrialView: ScrollTrialView) -> Int {
        return 0
    }
    
    func destinationRow(_ scrollTrialView: ScrollTrialView) -> Int {
        return 2
    }
    
    func axis(_ scrollTrialView: ScrollTrialView) -> ScrollTrial.Axis {
        return .horizontal
    }
}

//private func rowGenerator(repeats: Int) -> [(DragAndDropTrialView.Distance, DragAndDropTrialView.Direction)] {
//    return [.short, .long].flatMap { distance in
//        return [.right, .upRight, .up, .upLeft, .left, .downLeft, .down, .downRight].map { direction in (distance, direction) }
//    }
//}
