//
//  LongPressTaskTrialViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/8/10.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class LongPressTaskTrialViewController: TaskTrialViewController<LongPressTrial> {
    
    let tapTrialView = TapTrialView()
    
    var numberOfColumns = 5
    var numberOfRows = 5
    var numberOfRepeats = 1
    
    private var totalTrialsCount: Int = 0
    
    private var positions: [(Int, Int)] = [] {
        didSet { updateNextButton() }
    }
    
    override func nextViewController() -> TaskViewController<LongPressTrial>? {
        return TaskEndViewController()
    }
    
    override func dismissConfirmTitle() -> String? {
        return "Are you sure?"
    }
    
    override func dismissConfirmMessage() -> String? {
        return "Data will be deleted."
    }
    
    override func trialView() -> (UIView & TrialViewProtocol) {
        return tapTrialView
    }
    
    override func prefersNextButtonEnabled() -> Bool {
        return positions.isEmpty
    }
    
    override func instructionText() -> String {
        return "按下開始按鈕開始測驗，十字會出現在空白畫面中的任意位置，請用一隻手指點擊一次十字。"
    }
    
    override func actionTitle() -> String {
        return "開始"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        positions = positionGenerator(columns: numberOfColumns, rows: numberOfRows, repeats: numberOfRepeats).shuffled()
        totalTrialsCount = positions.count
        
        title = "點擊測驗 1/\(totalTrialsCount)"
        
        navigationItem.rightBarButtonItem?.title = "1/\(totalTrialsCount)"
        
        //tapTrialView.dataSource = self
    }
    
    override func didEndTrial() {
        super.didEndTrial()
        
        
        // add new trial to events manager
        var tapTrial = TapTrial(targetLocation: tapTrialView.targetView.center)
        tapTrial.startTime = trialStartDate.timeIntervalSince1970
        tapTrial.endTime = trialEndDate.timeIntervalSince1970
        tapTrial.rawTouchTracks = tapTrialView.rawTracks
        tapTrial.success = tapTrialView.success
        tapTrial.allEvents = tapTrialView.gestureRecognizerEvents
        
        //task?.trials.append(tapTrial)
        // end of add new trial
        
        
        positions.removeFirst()
        
        if !positions.isEmpty {
            tapTrialView.reloadData()
            title = "點擊測驗 \(totalTrialsCount - positions.count + 1)/\(totalTrialsCount)"
            navigationItem.rightBarButtonItem?.title = "\(totalTrialsCount - positions.count + 1)/\(totalTrialsCount)"
        } else {
            presentNext()
        }
    }
}

extension LongPressTaskTrialViewController: TapTrialViewDataSource {
    
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
}

private func positionGenerator(columns: Int, rows: Int, repeats: Int) -> [(Int, Int)] {
    return (0..<repeats).flatMap { _ in (0..<columns).flatMap { c in (0..<rows).map { r in (c, r) } } }
}
