//
//  ScrollInstructionViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/19.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class ScrollTaskInstructionViewController: TaskInstructionViewController<ScrollTrial> {
    
    let instructionView = ScrollInstructionView()
    
    var axis = ScrollTrial.Axis.vertical
    
    override func nextViewController() -> TaskViewController<ScrollTrial>? {
        let vc = ScrollTaskPracticeViewController()
        vc.axis = axis
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        titleLabel.text = "滾動測驗"
        instructionLabel.text = "direction, gesture, next, right, swipe, touch icon"
        
        contentView.addSubview(instructionView)
        instructionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            instructionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            instructionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            instructionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            instructionView.widthAnchor.constraint(equalTo: contentView.readableContentGuide.widthAnchor, multiplier: 0.8, constant: 0.0)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        instructionView.startAnimating()
    }
}
