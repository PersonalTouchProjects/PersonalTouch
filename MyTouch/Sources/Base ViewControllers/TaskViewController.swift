//
//  TaskViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/21.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {

    var taskResultManager: TaskResultManager?
    
    func nextViewController() -> TaskViewController? {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
}
