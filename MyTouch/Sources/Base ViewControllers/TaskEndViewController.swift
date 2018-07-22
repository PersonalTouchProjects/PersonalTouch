//
//  TrialEndViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/1.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TaskEndViewController<T: Trial>: TaskViewController<T> {

    let titleLabel    = UILabel()
    let actionButton = UIButton(type: .custom)
    
    override func nextViewController() -> TaskViewController<T>? {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)]
        
        titleLabel.text = NSLocalizedString("Tap Task End Title", comment: "")
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        actionButton.setTitle(NSLocalizedString("Back to tasks", comment: ""), for: .normal)
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.setBackgroundImage(UIImage.primaryButtonBackgroundImage(color: view.tintColor), for: .normal)
        actionButton.addTarget(self, action: #selector(handleButton(_:)), for: .touchUpInside)
        
        view.addSubview(titleLabel)
        view.addSubview(actionButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            titleLabel.topAnchor.constraintEqualToSystemSpacingBelow(view.safeAreaLayoutGuide.topAnchor, multiplier: 10),
            
            actionButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 343),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
            
            view.bottomAnchor.constraintEqualToSystemSpacingBelow(actionButton.bottomAnchor, multiplier: 5.0)
        ])
    }
    
    @objc private func handleButton(_ sender: UIButton) {
        primaryButtonDidSelect()
    }
    
    func primaryButtonDidSelect() {
        
//        do {
//            try taskResultManager?.session.archive()
//        } catch {
//            print("archive error: \(error)")
//        }
        
        if let taskViewController = nextViewController() {
            taskViewController.task = task
//            taskViewController.taskResultManager = taskResultManager
            navigationController?.pushViewController(taskViewController, animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
}
