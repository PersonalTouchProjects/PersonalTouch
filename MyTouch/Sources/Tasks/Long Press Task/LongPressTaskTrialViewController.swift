//
//  LongPressTaskTrialViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/8/10.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class LongPressTaskTrialViewController: TaskTrialViewController<LongPressTrial> {
    
    let longPressTrialView = LongPressTrialView()
    
    var numberOfColumns = 3
    var numberOfRows = 3
    var numberOfRepeats = 1
    
    private var totalTrialsCount: Int = 0
    
    private var positions: [(Int, Int, CGSize)] = [] {
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
        return longPressTrialView
    }
    
    override func prefersNextButtonEnabled() -> Bool {
        return positions.isEmpty
    }
    
    override func instructionText() -> String {
        return "按下開始按鈕開始測驗，方框會出現在空白畫面中的任意位置，請用一隻手指長按方框直到方框變為綠色。"
    }
    
    override func actionTitle() -> String {
        return "開始"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let smalls = positionGenerator(
            columns: numberOfColumns,
            rows: numberOfRows,
            size: CGSize(width: 44, height: 44),
            repeats: numberOfRepeats
        )
        let larges = positionGenerator(
            columns: numberOfColumns,
            rows: numberOfRows,
            size: CGSize(width: 76, height: 76),
            repeats: numberOfRepeats
        )
        
        positions = larges.shuffled() + smalls.shuffled()
        totalTrialsCount = positions.count
        
        title = "點擊測驗 1/\(totalTrialsCount)"
        
        navigationItem.rightBarButtonItem?.title = "1/\(totalTrialsCount)"
        
        longPressTrialView.dataSource = self
    }
    
    override func didEndTrial() {
        super.didEndTrial()
        
        
        // add new trial to events manager
        var trial = LongPressTrial(targetFrame: longPressTrialView.targetView.frame)
        trial.startTime = trialStartDate.timeIntervalSince1970
        trial.endTime = trialEndDate.timeIntervalSince1970
        trial.rawTouchTracks = longPressTrialView.rawTracks
        trial.success = longPressTrialView.success
        trial.allEvents = longPressTrialView.gestureRecognizerEvents
        
        task?.trials.append(trial)
        // end of add new trial
        
        
        positions.removeFirst()
        
        if !positions.isEmpty {
            longPressTrialView.reloadData()
            title = "點擊測驗 \(totalTrialsCount - positions.count + 1)/\(totalTrialsCount)"
            navigationItem.rightBarButtonItem?.title = "\(totalTrialsCount - positions.count + 1)/\(totalTrialsCount)"
        } else {
            presentNext()
        }
    }
}

extension LongPressTaskTrialViewController: LongPressTrialViewDataSource {
    
    func numberOfColumn(_ tapTrialView: LongPressTrialView) -> Int {
        return numberOfColumns
    }
    
    func numberOfRow(_ tapTrialView: LongPressTrialView) -> Int {
        return numberOfRows
    }
    
    func targetColumn(_ tapTrialView: LongPressTrialView) -> Int {
        return positions.first!.0
    }
    
    func targetRow(_ tapTrialView: LongPressTrialView) -> Int {
        return positions.first!.1
    }
    
    func targetSize(_ tapTrialView: LongPressTrialView) -> CGSize {
        return positions.first!.2
    }
}

private func positionGenerator(columns: Int, rows: Int, size: CGSize, repeats: Int) -> [(Int, Int, CGSize)] {
    return (0..<repeats).flatMap { _ in (0..<columns).flatMap { c in (0..<rows).map { r in (c, r, size) } } }
}
