//
//  TapTaskInstructionViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/6.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TapTaskInstructionViewController: TaskInstructionViewController {

    override func nextViewController() -> (UIViewController & TaskResultManagerViewController) {
        return TapTaskPracticeViewController()
    }
    
}
