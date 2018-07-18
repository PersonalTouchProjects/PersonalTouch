//
//  TapTaskInstructionViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/6.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TapTaskInstructionViewController: TaskInstructionViewController {

    let instructionView = TapInstructionView()
    
    override func nextViewController() -> (UIViewController & TaskResultManagerViewController)? {
        return TapTaskPracticeViewController()
//        return SwipeTaskPracticeViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.addSubview(instructionView)
        instructionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            instructionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            instructionView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        instructionView.startAnimating()
    }
}
