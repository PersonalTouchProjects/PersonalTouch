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
    let countDownView = CountdownView()
    
    private(set) var trialStartDate = Date.distantPast
    private(set) var trialEndDate = Date.distantFuture
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        actionButton.setTitle(NSLocalizedString("Next Trial", comment: ""), for: .normal)
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.setBackgroundImage(UIImage.buttonBackgroundImage(color: view.tintColor), for: .normal)
        actionButton.addTarget(self, action: #selector(handleActionButton(_:)), for: .touchUpInside)
        
        cancelButton.setTitle(NSLocalizedString("Withdraw Exam", comment: ""), for: .normal)
        cancelButton.addTarget(self, action: #selector(handleCancelButton(_:)), for: .touchUpInside)
        
        view.addSubview(actionButton)
        view.addSubview(cancelButton)
        view.addSubview(countDownView)
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        countDownView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            cancelButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            actionButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -20),
            actionButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 343),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
            
            countDownView.topAnchor.constraint(equalTo: view.topAnchor),
            countDownView.leftAnchor.constraint(equalTo: view.leftAnchor),
            countDownView.rightAnchor.constraint(equalTo: view.rightAnchor),
            countDownView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
    
    func startTrial(countdown: TimeInterval = 0.0) {
        
        countDownView.isHidden = false
        countDownView.countdown = countdown
        countDownView.fire {
            
            self.countDownView.isHidden = true
            
            self.trialStartDate = Date()
            self.trialEndDate = Date.distantFuture
            
            self.view.addSubview(self.trialView)
            self.trialView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                self.trialView.topAnchor.constraint(equalTo: self.view.topAnchor),
                self.trialView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                self.trialView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                self.trialView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
            
            self.trialView.layoutIfNeeded()
        }
    }
    
    func endTrial() {
        trialEndDate = Date()
        trialView.removeFromSuperview()
    }
}
