//
//  ScrollTrialViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/19.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class ScrollTaskTrialViewController: TaskTrialViewController<ScrollTrial> {
    
    let scrollTrialView = ScrollTrialView(frame: .zero)
    
    var axis = ScrollTrial.Axis.vertical
    var rows = 200
    var numberOfRepeats = 2
    var positionAndOffsets: [(Int, Int)] = [] {
        didSet { updateNextButton() }
    }
    
    private var totalTrialsCount: Int = 0
    
    override func nextViewController() -> TaskViewController<ScrollTrial>? {
        return TaskEndViewController()
    }
    
    override func trialView() -> (UIView & TrialViewProtocol) {
        return scrollTrialView
    }
    
    override func prefersNextButtonEnabled() -> Bool {
        return positionAndOffsets.isEmpty
    }
    
    override func dismissConfirmTitle() -> String? {
        return "Are you sure?"
    }
    
    override func dismissConfirmMessage() -> String? {
        return "Data will be deleted."
    }
    
    override func instructionText() -> String {
        return """
        按下開始按鈕開始測驗，請將藍色矩形滾動至目標區域。
        """
    }
    
    override func actionTitle() -> String {
        return "開始"
    }
    
    override func timeIntervalBeforeEndTrial() -> TimeInterval {
        return scrollTrialView.timeIntervalBeforeStopDecelarating + 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        positionAndOffsets = positionAndOffsetsGenerator(total: rows, repeats: numberOfRepeats).shuffled()
        totalTrialsCount = positionAndOffsets.count
//        positions = positionGenerator(rows: rows, targetRow: targetRow, repeats: numberOfRepeats).shuffled()
        
        title = "滾動測驗 1/\(totalTrialsCount)"
        navigationItem.rightBarButtonItem?.title = "1/\(totalTrialsCount)"
        
        scrollTrialView.isScrollEnabled = false
        scrollTrialView.trialDataSource = self
        
        countDownView.label.textColor = .white
    }
    
    override func didStartTrial() {
        super.didStartTrial()
        scrollTrialView.isScrollEnabled = true
    }
    
    override func didEndTrial() {
        super.didEndTrial()
        
        scrollTrialView.isScrollEnabled = false
        
        // handle trial result
        var trial = ScrollTrial(axis: axis, initialPosition: scrollTrialView.initialOffset, targetPosition: scrollTrialView.targetOffset)
        trial.endDraggingPosition = scrollTrialView.endDraggingOffset
        trial.predictedPosition = scrollTrialView.predictedOffset

        trial.startTime = trialStartDate.timeIntervalSince1970
        trial.endTime = trialEndDate.timeIntervalSince1970
        trial.rawTouchTracks = scrollTrialView.rawTracks
        trial.success = scrollTrialView.success
        trial.allEvents = scrollTrialView.gestureRecognizerEvents

        task?.trials.append(trial)
        // end of add new trial
        
        positionAndOffsets.removeFirst()
        
        if !positionAndOffsets.isEmpty  {
            scrollTrialView.reloadData()
            title = "滾動測驗 \(totalTrialsCount - positionAndOffsets.count + 1)/\(totalTrialsCount)"
            navigationItem.rightBarButtonItem?.title = "\(totalTrialsCount - positionAndOffsets.count + 1)/\(totalTrialsCount)"
        } else {
            presentNext()
        }
    }
}

extension ScrollTaskTrialViewController: ScrollTrialViewDataSource {
    
    func numberOfItems(_ scrollTrialView: ScrollTrialView) -> Int {
        return rows
    }
    
    func initialItem(_ scrollTrialView: ScrollTrialView) -> Int {
        return positionAndOffsets.first!.0
    }
    
    func targetItem(_ scrollTrialView: ScrollTrialView) -> Int {
        return positionAndOffsets.first!.0 + positionAndOffsets.first!.1
    }
    
    func axis(_ scrollTrialView: ScrollTrialView) -> ScrollTrial.Axis {
        return axis
    }
}

private func positionAndOffsetsGenerator(total: Int, repeats: Int) -> [(Int, Int)] {
    let center = total / 2
    let value = [-5, -3, 3, 5].compactMap { offset in
        return (center, offset)
    }
    
    var result = [(Int, Int)]()
    for _ in (0..<repeats)  {
        result += value
    }
    
    return result
}
