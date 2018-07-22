//
//  RotationTaskInstructionViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/20.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class RotationTaskInstructionViewController: TaskInstructionViewController<RotationTrial> {
    
    let instructionView = RotationInstructionView()
    
    override func nextViewController() -> TaskViewController<RotationTrial>? {
        return RotationTaskPracticeViewController()
    }
    
    override func instructionText() -> String {
        return """
        旋轉測驗
        本測驗共有 8 次嘗試，請將指北針旋轉至指向正北。
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
