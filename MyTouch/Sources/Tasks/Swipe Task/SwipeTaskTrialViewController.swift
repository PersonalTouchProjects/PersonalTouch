//
//  SwipeTaskTrialViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/18.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class SwipeTaskTrialViewController: TaskTrialViewController<SwipeTrial> {
    
    let swipeTrialView = SwipeTrialView()
    
    var numberOfRepeats = 1
    var directions: [(SwipeTrialView.SwipeArea, SwipeTrial.Direction)] = [] {
        didSet { updateNextButton() }
    }
    private var totalTrialsCount: Int = 0
    
    override func nextViewController() -> TaskViewController<SwipeTrial>? {
        return TaskEndViewController()
    }
    
    override func trialView() -> (UIView & TrialViewProtocol) {
        return swipeTrialView
    }
    
    override func prefersNextButtonEnabled() -> Bool {
        return directions.isEmpty
    }
    
    override func dismissConfirmTitle() -> String? {
        return "Are you sure?"
    }
    
    override func dismissConfirmMessage() -> String? {
        return "Data will be deleted."
    }
    
    override func instructionText() -> String {
        return """
        按下開始按鈕開始測驗，請在畫面的左邊或右邊順著箭頭方向快速掃動。
        """
    }
    
    override func actionTitle() -> String {
        return "開始"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        directions = directionGenerator(repeats: numberOfRepeats).shuffled()
        totalTrialsCount = directions.count
        
        title = "掃動測驗 1/\(totalTrialsCount)"
        navigationItem.rightBarButtonItem?.title = "1/\(totalTrialsCount)"
        
        swipeTrialView.dataSource = self
        countDownView.label.textColor = .white
    }
    
    override func didEndTrial() {
        super.didEndTrial()
        
        // handle trial result
        let areaFrame = swipeTrialView.areaView.frame
        let targetDirection = directions.first!.1
        
        var swipeTrial = SwipeTrial(areaFrame: areaFrame, targetDirection: targetDirection)
        swipeTrial.startTime = trialStartDate.timeIntervalSince1970
        swipeTrial.endTime = trialEndDate.timeIntervalSince1970
        swipeTrial.rawTouchTracks = swipeTrialView.rawTracks
        swipeTrial.success = targetDirection == swipeTrialView.recognizedDirection
        swipeTrial.allEvents = swipeTrialView.gestureRecognizerEvents
        
        task?.trials.append(swipeTrial)
        // end of add new trial
        
        directions.removeFirst()
        
        if !directions.isEmpty {
            swipeTrialView.reloadData()
            title = "掃動測驗 \(totalTrialsCount - directions.count + 1)/\(totalTrialsCount)"
            navigationItem.rightBarButtonItem?.title = "\(totalTrialsCount - directions.count + 1)/\(totalTrialsCount)"
        } else {
            presentNext()
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

private func directionGenerator(repeats: Int) -> [(SwipeTrialView.SwipeArea, SwipeTrial.Direction)] {
    
//    return [(.right, .right)]
    
    return (0..<repeats).flatMap { _ in
        return [.left, .right].flatMap { area in
            return [.right, .upRight, .up, .upLeft, .left, .downLeft, .down, .downRight].map { direction in (area, direction) }
        }
    }
}
