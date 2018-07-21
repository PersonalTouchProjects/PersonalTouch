//
//  ScrollPracticeViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/19.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class ScrollTaskPracticeViewController: TaskTrialViewController {
    
    let scrollTrialView = ScrollTrialView()
    
    var shouldStartTrial = false
    
    override func nextViewController() -> TaskViewController {
        return ScrollTaskTrialViewController()
    }
    
    override func trialView() -> (UIView & TrialViewProtocol) {
        return scrollTrialView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollTrialView.scrollView.isScrollEnabled = false
        scrollTrialView.dataSource = self
        
        actionButton.setTitle("Practice", for: .normal)
    }
    
    override func didStartTrial() {
        super.didStartTrial()
        scrollTrialView.scrollView.isScrollEnabled = true
    }
    
    override func didEndTrial() {
        super.didEndTrial()
        
        scrollTrialView.scrollView.isScrollEnabled = false
        scrollTrialView.reloadData()
        
        shouldStartTrial = true
        
        UIView.performWithoutAnimation {
            self.actionButton.setTitle("End Practice", for: .normal)
        }
    }
    
//    override func primaryButtonDidSelect() {
//        super.primaryButtonDidSelect()
//        
//        if shouldStartTrial {
////            presentStartTrialAlert()
//        } else {
//            startTrial()
//        }
//    }
    
//    override func secondaryButtonDidSelect() {
//        super.secondaryButtonDidSelect()
//        
//        if shouldStartTrial {
//            startTrial()
//        } else {
//            presentStartTrialAlert()
//        }
//    }
    
//    private func presentStartTrialAlert() {
//        
//        let alertController = UIAlertController(title: "Start Trial", message: "Are you sure?", preferredStyle: .alert)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
//        let confirmAction = UIAlertAction(title: "Go", style: .default) { (action) in
//            self.presentNextViewController()
//        }
//        
//        alertController.addAction(cancelAction)
//        alertController.addAction(confirmAction)
//        alertController.preferredAction = confirmAction
//        
//        present(alertController, animated: true, completion: nil)
//    }
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
        return .horizontal
    }
}
