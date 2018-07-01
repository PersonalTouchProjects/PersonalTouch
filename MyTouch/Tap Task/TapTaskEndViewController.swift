//
//  TapTaskEndViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/1.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TapTaskEndViewController: TaskEndViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func actionButtonDidSelect() {
        super.actionButtonDidSelect()
        
        dismiss(animated: true, completion: nil)
    }
    
    override func cancelButtonDidSelect() {
        super.actionButtonDidSelect()
        
        dismiss(animated: true, completion: nil)
    }

}
