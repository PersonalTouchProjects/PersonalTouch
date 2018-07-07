//
//  TapTaskPracticeViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/8.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TapTaskPracticeViewController: TaskTrialViewController {

    let tapTrialView = TapTrialView()
    
    var shouldStartTrial = false
    
    override func loadView() {
        super.loadView()
        self.trialView = tapTrialView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapTrialView.delegate = self
        tapTrialView.dataSource = self
        
        primaryButton.setTitle("Practice", for: .normal)
        secondaryButton.setTitle("Skip", for: .normal)
    }
    
    override func didEndTrial() {
        super.didEndTrial()
        
        tapTrialView.reloadData()
        
        shouldStartTrial = true
        
        primaryButton.setTitle("End Practice", for: .normal)
        secondaryButton.setTitle("Try Again", for: .normal)
    }
    
    override func primaryButtonDidSelect() {
        
        // do not call super to avoid start trial automatically.
        // super.primaryButtonDidSelect()
        //
        
        if shouldStartTrial {
            let trialViewController = TapTaskTrialViewController()
            navigationController?.pushViewController(trialViewController, animated: true)
        } else {
            startTrial()
        }
    }
    
    override func secondaryButtonDidSelect() {
        super.secondaryButtonDidSelect()
        
        if shouldStartTrial {
            startTrial()
        } else {
            let trialViewController = TapTaskTrialViewController()
            navigationController?.pushViewController(trialViewController, animated: true)
        }
    }
}

extension TapTaskPracticeViewController: TapTrialViewDataSource {
    
    func numberOfColumn(_ tapTrialView: TapTrialView) -> Int {
        return 5
    }
    
    func numberOfRow(_ tapTrialView: TapTrialView) -> Int {
        return 5
    }
    
    func targetColumn(_ tapTrialView: TapTrialView) -> Int {
        return Int(arc4random() % 5)
    }
    
    func targetRow(_ tapTrialView: TapTrialView) -> Int {
        return Int(arc4random() % 5)
    }
    
    func targetSize(_ tapTrialView: TapTrialView) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}
