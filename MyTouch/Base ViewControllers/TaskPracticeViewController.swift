//
//  TaskViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/30.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TaskPracticeViewController: UIViewController {
    
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let feedbackLabel = UILabel()
    
    var practiceView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            
            if let newView = practiceView {
                
                self.view.addSubview(newView)
                newView.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    newView.topAnchor.constraintEqualToSystemSpacingBelow(descriptionLabel.bottomAnchor, multiplier: 1.0),
                    newView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
                    newView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
                    actionButton.topAnchor.constraintEqualToSystemSpacingBelow(newView.bottomAnchor, multiplier: 1.0)
                ])
    
                newView.setContentHuggingPriority(.defaultLow, for: .vertical)
            }
        }
    }
    
    let actionButton = UIButton(type: .custom)
    let cancelButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        titleLabel.text = NSLocalizedString("Tap Task Title", comment: "")
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        descriptionLabel.text = NSLocalizedString("Tap Task Description", comment: "")
        descriptionLabel.font = UIFont.systemFont(ofSize: 28, weight: .light)
        
        feedbackLabel.text = NSLocalizedString("Very Good", comment: "")
        feedbackLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        actionButton.setTitle(NSLocalizedString("Start Exam", comment: ""), for: .normal)
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.setBackgroundImage(UIImage.buttonBackgroundImage(color: view.tintColor), for: .normal)
        actionButton.addTarget(self, action: #selector(handleActionButton(_:)), for: .touchUpInside)
        
        cancelButton.setTitle(NSLocalizedString("Start Exam", comment: ""), for: .normal)
        cancelButton.addTarget(self, action: #selector(handleCancelButton(_:)), for: .touchUpInside)
        
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(feedbackLabel)
        view.addSubview(actionButton)
        view.addSubview(cancelButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        feedbackLabel.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            cancelButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            actionButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -20),
            actionButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 343),
            actionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        let topSpacing = UILayoutGuide()
        let bottomSpacing = UILayoutGuide()
        
        view.addLayoutGuide(topSpacing)
        view.addLayoutGuide(bottomSpacing)
        
        NSLayoutConstraint.activate([
            topSpacing.topAnchor.constraintEqualToSystemSpacingBelow(descriptionLabel.bottomAnchor, multiplier: 1.0),
            
            feedbackLabel.topAnchor.constraint(equalTo: topSpacing.bottomAnchor),
            feedbackLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            feedbackLabel.bottomAnchor.constraint(equalTo: bottomSpacing.topAnchor),
            
            actionButton.topAnchor.constraintEqualToSystemSpacingBelow(bottomSpacing.bottomAnchor, multiplier: 1.0),
            
            topSpacing.heightAnchor.constraint(equalTo: bottomSpacing.heightAnchor, multiplier: 2)
        ])
        
        feedbackLabel.isHidden = true
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
}
