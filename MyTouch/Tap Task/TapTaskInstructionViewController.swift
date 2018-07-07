//
//  TapTaskInstructionViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/6.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TapTaskInstructionViewController: TaskInstructionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func primaryButtonDidSelect() {
        super.primaryButtonDidSelect()
        
        let taskViewController = TapTaskPracticeViewController()
        navigationController?.pushViewController(taskViewController, animated: true)
    }
}
