//
//  SwipeTaskInstructionViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/18.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class SwipeTaskInstructionViewController: TaskInstructionViewController<SwipeTrial> {
    
    let instructionView = SwipeInstructionView()
    
    override func nextViewController() -> TaskViewController<SwipeTrial>? {
        return SwipeTaskPracticeViewController()
    }
    
    override func instructionText() -> String {
        return """
        掃動測驗
        本測驗共有 8 次嘗試，每次嘗試會需要在畫面上順著箭頭方向快速掃動。
        """
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
