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
    
    @objc final func presentNext() {
        
        if let taskViewController = nextViewController() {
            taskViewController.taskResultManager = taskResultManager
            navigationController?.pushViewController(taskViewController, animated: true)
        } else {
            // TODO: - Archive task data
        }
    }
    
    @objc final func dismissTask() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc final func dismissTaskWithConfimation() {
        
        let alertController = UIAlertController(title: "Are You Sure?", message: "All data will be discarded.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Leave", style: .destructive) { (action) in
            self.dismissTask()
        }
        let cancelAction = UIAlertAction(title: "Stay", style: .default, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        alertController.preferredAction = cancelAction
        
        present(alertController, animated: true, completion: nil)
    }
}
