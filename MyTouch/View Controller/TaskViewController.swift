//
//  TaskViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/30.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {
    
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let feedbackLabel = UILabel()
    
    var tutorialView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            
            if let newView = tutorialView {
                
                self.view.addSubview(newView)
                newView.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    newView.topAnchor.constraintEqualToSystemSpacingBelow(descriptionLabel.bottomAnchor, multiplier: 1.0),
                    newView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
                    newView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
                    startButton.topAnchor.constraintEqualToSystemSpacingBelow(newView.bottomAnchor, multiplier: 1.0)
                ])
    
                newView.setContentHuggingPriority(.defaultLow, for: .vertical)
            }
        }
    }
    
    let startButton = UIButton(type: .custom)
    let stopButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        titleLabel.text = NSLocalizedString("Tap Task Title", comment: "")
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        descriptionLabel.text = NSLocalizedString("Tap Task Description", comment: "")
        descriptionLabel.font = UIFont.systemFont(ofSize: 28, weight: .light)
        
        feedbackLabel.text = NSLocalizedString("Very Good", comment: "")
        feedbackLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        startButton.setTitle(NSLocalizedString("Start Exam", comment: ""), for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.setBackgroundImage(UIImage.buttonBackgroundImage(color: view.tintColor), for: .normal)
        
        stopButton.setTitle(NSLocalizedString("Start Exam", comment: ""), for: .normal)
        stopButton.addTarget(self, action: #selector(handleStopButton(_:)), for: .touchUpInside)
        
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(feedbackLabel)
        view.addSubview(startButton)
        view.addSubview(stopButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        feedbackLabel.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            stopButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            stopButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            startButton.bottomAnchor.constraint(equalTo: stopButton.topAnchor, constant: -20),
            startButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 343),
            startButton.heightAnchor.constraint(equalToConstant: 50)
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
            
            startButton.topAnchor.constraintEqualToSystemSpacingBelow(bottomSpacing.bottomAnchor, multiplier: 1.0),
            
            topSpacing.heightAnchor.constraint(equalTo: bottomSpacing.heightAnchor, multiplier: 2)
        ])
        
        feedbackLabel.isHidden = true
    }
    
    @objc func handleStopButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
