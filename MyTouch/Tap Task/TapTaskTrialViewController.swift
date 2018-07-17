//
//  TapTaskTrialViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/1.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TapTaskTrialViewController: TaskTrialViewController {
    
    let tapTrialView = TapTrialView()
    
    var numberOfColumns = 2
    var numberOfRows = 2
    var numberOfRepeats = 1
    
    var positions: [(Int, Int)] = []
    
    override func nextViewController() -> (UIViewController & EventsManagerViewController)? {
        return TaskEndViewController()
    }
    
    override func loadView() {
        super.loadView()
        self.trialView = tapTrialView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        positions = positionGenerator(columns: numberOfColumns, rows: numberOfRows, repeats: numberOfRepeats) //.shuffled()
        
        tapTrialView.delegate = self
        tapTrialView.dataSource = self
    }
    
    override func didEndTrial() {
        super.didEndTrial()
        
        
        // add new trial to events manager
        var tapTrial = TapTrial(targetLocation: tapTrialView.targetView.center)
        tapTrial.startTime = trialStartDate.timeIntervalSince1970
        tapTrial.endTime = trialEndDate.timeIntervalSince1970
        tapTrial.rawTouchTracks = tapTrialView.rawTracks
        tapTrial.gestureRecognizerEvents = tapTrialView.gestureRecognizerEvents
        tapTrial.success = tapTrialView.success
        
        eventsManager?.addTrial(tapTrial)
        // end of add new trial
        
        
        positions.removeFirst()
        
        if positions.isEmpty {
            
            let alertController = UIAlertController(title: "You're done!", message: "Go away.", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "OK", style: .destructive) { (action) in
                
                if let taskViewController = self.nextViewController() {
                    taskViewController.eventsManager = self.eventsManager
                    self.navigationController?.pushViewController(taskViewController, animated: true)
                }
            }
            
            alertController.addAction(confirmAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            tapTrialView.reloadData()
            titleLabel.text = NSLocalizedString("Tap Task Title", comment: "") + " (25 之 \(25 - positions.count + 1))"
        }
    }
}

extension TapTaskTrialViewController: TapTrialViewDataSource {
    
    func numberOfColumn(_ tapTrialView: TapTrialView) -> Int {
        return numberOfColumns
    }
    
    func numberOfRow(_ tapTrialView: TapTrialView) -> Int {
        return numberOfRows
    }
    
    func targetColumn(_ tapTrialView: TapTrialView) -> Int {
        return positions.first!.0
    }
    
    func targetRow(_ tapTrialView: TapTrialView) -> Int {
        return positions.first!.1
    }
    
    func targetSize(_ tapTrialView: TapTrialView) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}

func positionGenerator(columns: Int, rows: Int, repeats: Int) -> [(Int, Int)] {
    return (0..<repeats).flatMap { _ in (0..<columns).flatMap { c in (0..<rows).map { r in (c, r) } } }
}
