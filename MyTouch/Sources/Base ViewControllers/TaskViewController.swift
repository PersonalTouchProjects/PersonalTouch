//
//  TaskViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/21.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TaskViewController<T: Trial>: UIViewController {

    var task: Task<T>?
    
//    var taskResultManager: TaskResultManager?
    
    func nextViewController() -> TaskViewController? { return nil }
    
    func presentNextConfirmTitle() -> String? { return nil }
    
    func presentNextConfirmMessage() -> String? { return nil }
    
    func dismissConfirmTitle() -> String? { return nil }
    
    func dismissConfirmMessage() -> String? { return nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    @objc final func presentNext() {
        
        if let taskViewController = nextViewController() {
            
            taskViewController.task = task
//            taskViewController.taskResultManager = taskResultManager
            
            let animated = false
            
            let alertTitle = presentNextConfirmTitle()
            let message    = presentNextConfirmMessage()
            
            if alertTitle != nil || message != nil {
                
                let alertController = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                let confirmAction = UIAlertAction(title: "Go", style: .default) { (action) in
                    self.navigationController?.pushViewController(taskViewController, animated: animated)
                }
                
                alertController.addAction(cancelAction)
                alertController.addAction(confirmAction)
                alertController.preferredAction = confirmAction
                
                present(alertController, animated: true, completion: nil)
            } else {
                navigationController?.pushViewController(taskViewController, animated: animated)
            }
            
        } else {
            // TODO: - Archive task data
        }
    }
    
    @objc final func dismissTask() {
        
        let animated = false
        
        let alertTitle = dismissConfirmTitle()
        let message    = dismissConfirmMessage()
        
        if alertTitle != nil || message != nil {
            
            let alertController = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Leave", style: .destructive) { (action) in
                
                self.task?.trials.removeAll()
                self.dismiss(animated: animated, completion: nil)
            }
            let cancelAction = UIAlertAction(title: "Stay", style: .default, handler: nil)
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            alertController.preferredAction = cancelAction
            
            present(alertController, animated: true, completion: nil)
        } else {
            
            task?.trials.removeAll()
            dismiss(animated: animated, completion: nil)
        }
    }
}
