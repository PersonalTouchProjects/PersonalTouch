//
//  AccommodatedViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/31.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class AccommodatedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "觸控調節"
        
        view.backgroundColor = .white
        
        let recognizer = AccommodatedTapGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        recognizer.delegate = self
        recognizer.holdDuration = 1.0
        recognizer.ignoreRepeat = 1.0
        view.addGestureRecognizer(recognizer)
        
        let pan = AccommodatedPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        pan.delegate = self
        pan.ignoreRepeat = 1.0
//        view.addGestureRecognizer(pan)
    }

    @objc private func handleGesture(_ sender: UIGestureRecognizer) {
        print(sender, sender.location(in: view))
    }
}

extension AccommodatedViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
