//
//  ScrollPracticeViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/19.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class ScrollTaskPracticeViewController: TaskTrialViewController<ScrollTrial> {
    
    let scrollTrialView = ScrollTrialView()
    
    override func nextViewController() -> TaskViewController<ScrollTrial>? {
        let vc = ScrollTaskTrialViewController()
        vc.axis = axis
        return vc
    }
    
    override func presentNextConfirmTitle() -> String? {
        return "Start Trials?"
    }
    
    override func trialView() -> (UIView & TrialViewProtocol) {
        return scrollTrialView
    }
    
    var axis = ScrollTrial.Axis.vertical
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        scrollTrialView.reloadData()
    }
}

extension ScrollTaskPracticeViewController: ScrollTrialViewDataSource {
    
    func numberOfRows(_ scrollTrialView: ScrollTrialView) -> Int {
        return 5
    }
    
    func targetRow(_ scrollTrialView: ScrollTrialView) -> Int {
        return [0,1,3,4].shuffled().first!
    }
    
    func destinationRow(_ scrollTrialView: ScrollTrialView) -> Int {
        return 2
    }
    
    func axis(_ scrollTrialView: ScrollTrialView) -> ScrollTrial.Axis {
        return axis
    }
}
