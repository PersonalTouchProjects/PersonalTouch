//
//  TrialViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/1.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TaskTrialViewController: UIViewController {

    let actionButton = UIButton(type: .custom)
    let cancelButton = UIButton(type: .system)
    
    var trialView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        actionButton.setTitle(NSLocalizedString("Next Trial", comment: ""), for: .normal)
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.setBackgroundImage(UIImage.buttonBackgroundImage(color: view.tintColor), for: .normal)
        actionButton.addTarget(self, action: #selector(handleActionButton(_:)), for: .touchUpInside)
        
        cancelButton.setTitle(NSLocalizedString("Start Exam", comment: ""), for: .normal)
        cancelButton.addTarget(self, action: #selector(handleCancelButton(_:)), for: .touchUpInside)
        
        view.addSubview(actionButton)
        view.addSubview(cancelButton)
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            cancelButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            actionButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -20),
            actionButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 343),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc private func handleActionButton(_ sender: UIButton) {
        actionButtonDidSelect()
    }
    
    @objc private func handleCancelButton(_ sender: UIButton) {
        cancelButtonDidSelect()
    }
    
    func actionButtonDidSelect() {
        
    }
    
    func cancelButtonDidSelect() {
        
    }
    
    func startTrial() {
        
        view.addSubview(trialView)
        trialView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trialView.topAnchor.constraint(equalTo: view.topAnchor),
            trialView.leftAnchor.constraint(equalTo: view.leftAnchor),
            trialView.rightAnchor.constraint(equalTo: view.rightAnchor),
            trialView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func endTrial() {
        
        trialView.removeFromSuperview()
    }
}
