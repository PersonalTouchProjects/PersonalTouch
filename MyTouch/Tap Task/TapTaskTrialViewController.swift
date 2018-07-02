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
    
    var positions = positionGenerator(columns: 2, rows: 2, repeats: 2).shuffled()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.trialView = tapTrialView
        tapTrialView.delegate = self
        tapTrialView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startTrial(countdown: 3)
    }
    
    override func actionButtonDidSelect() {
        super.actionButtonDidSelect()
        
        if positions.count == 0 {
            dismiss(animated: true, completion: nil)
        } else {
            startTrial(countdown: 3.0)
        }
    }
    
    override func cancelButtonDidSelect() {
        super.cancelButtonDidSelect()

        let alertController = UIAlertController(title: "Are You Sure?", message: "All data will be discarded.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Leave", style: .destructive) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Stay", style: .default, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        alertController.preferredAction = cancelAction
        
        present(alertController, animated: true, completion: nil)
    }
}

extension TapTaskTrialViewController: TapTrialViewDataSource {
    
    func numberOfColumn(_ tapTrialView: TapTrialView) -> Int {
        return 2
    }
    
    func numberOfRow(_ tapTrialView: TapTrialView) -> Int {
        return 2
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

extension TapTaskTrialViewController: TouchTrackingViewDelegate {
    
    func touchTrackingViewDidEndTracking(_ touchTrackingView: TouchTrackingView) {

        endTrial()
        
        print(tapTrialView.targetView.frame)
        print(tapTrialView.tracks)
        
        positions.removeFirst()
        
        if positions.count > 0 {
            actionButton.setTitle("Next (\(positions.count) left)", for: .normal)
        } else {
            actionButton.setTitle("Next Task", for: .normal)
        }
    }
}

func positionGenerator(columns: Int, rows: Int, repeats: Int) -> [(Int, Int)] {
    return (0..<repeats).flatMap { _ in (0..<columns).flatMap { c in (0..<rows).map { r in (c, r) } } }
}
