//
//  TapTaskInstructionViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/6.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TapTaskInstructionViewController: TaskInstructionViewController<TapTrial> {

    let instructionView = TapInstructionView()
    
    override func nextViewController() -> TaskViewController<TapTrial>? {
        return TapTaskPracticeViewController()
    }
    
    override func instructionText() -> String {
        return """
        點擊測驗
        本測驗共有 25 次嘗試，每次嘗試會有一個十字出現在空白畫面中的任意位置，請用一隻手指點擊一次十字。
        """
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.addSubview(instructionView)
        instructionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            instructionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            instructionView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            instructionView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            instructionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        instructionView.startAnimating()
    }
}
