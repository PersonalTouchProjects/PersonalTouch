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
        
        if let task = task as? Task<TapTrial> {
            SessionManager.shared.currentSession?.tapTask = task
        }
        if let task = task as? Task<SwipeTrial> {
            SessionManager.shared.currentSession?.swipeTask = task
        }
        if let task = task as? Task<DragAndDropTrial> {
            SessionManager.shared.currentSession?.dragAndDropTask = task
        }
        if let task = task as? ScrollTask {
            if task.isHorizontal {
                SessionManager.shared.currentSession?.horizontalScrollTask = task
            } else {
                SessionManager.shared.currentSession?.verticalScrollTask = task
            }
        }
        if let task = task as? Task<PinchTrial> {
            SessionManager.shared.currentSession?.pinchTask = task
        }
        if let task = task as? Task<RotationTrial> {
            SessionManager.shared.currentSession?.rotationTask = task
        }
        
        dismiss(animated: true, completion: nil)
    }
}
