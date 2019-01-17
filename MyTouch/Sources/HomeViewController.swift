//
//  HomeViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/1/10.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit

class HomeViewController: SessionDetailViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "MyTouch"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Test", style: .plain, target: self, action: #selector(handleNewTestButton(sender:)))
        
    }
    
    @objc private func handleNewTestButton(sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "New Test", message: "To infinity, and beyond!", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)

        alertController.addAction(action)
        alertController.preferredAction = action
        
        present(alertController, animated: true, completion: nil)
    }
}
