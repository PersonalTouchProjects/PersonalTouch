//
//  DragAndDropTrialViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/18.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class DragAndDropTaskPracticeViewController: TaskTrialViewController<DragAndDropTrial> {
    
    let dragAndDropTrialView = DragAndDropTrialView()
    
    override func nextViewController() -> TaskViewController<DragAndDropTrial>? {
        return DragAndDropTaskTrialViewController()
    }
    
    override func presentNextConfirmTitle() -> String? {
        return "Start Trials?"
    }
    
    override func trialView() -> (UIView & TrialViewProtocol) {
        return dragAndDropTrialView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dragAndDropTrialView.dataSource = self
    }
    
    override func didEndTrial() {
        super.didEndTrial()
        
        dragAndDropTrialView.reloadData()
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
