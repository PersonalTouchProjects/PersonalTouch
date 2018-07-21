//
//  TaskNavigationController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/21.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TaskNavigationController: UINavigationController {

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if viewController.navigationItem.leftBarButtonItem == nil {
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancelButton(_:)))
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc private func handleCancelButton(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Are You Sure?", message: "All data will be discarded.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Leave", style: .destructive) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Stay", style: .default, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        alertController.preferredAction = cancelAction
        
        present(alertController, animated: true, completion: nil)
    }
}
