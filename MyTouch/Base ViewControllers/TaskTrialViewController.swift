//
//  TrialViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/1.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

private var previewScale: CGFloat = 0.5

class TaskTrialViewController: UIViewController, TaskResultManagerViewController {

    let titleLabel = UILabel()
    let primaryButton = UIButton(type: .custom)
    let secondaryButton = UIButton(type: .system)
    let cancelButton = UIButton(type: .system)
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [secondaryButton, primaryButton])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 8.0
        return stack
    }()
    
    var trialView: TrialView = TrialView()
    
    private let maskView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private let whiteView = UIView()
    private let previewBorderView = UIView()
    private let countDownView = CountdownView()
    
    private let previewLayoutGuide = UILayoutGuide()
    private var previewConstraints = [NSLayoutConstraint]()
    private var fullSizeConstraints = [NSLayoutConstraint]()
    
    private(set) var trialStartDate = Date.distantPast
    private(set) var trialEndDate = Date.distantFuture
    
    var taskResultManager: TaskResultManager?

    func nextViewController() -> (UIViewController & TaskResultManagerViewController)? {
        return TaskTrialViewController()
    }
    
    var shouldStartTrialAutomaticallyOnPrimaryButtonTapped: Bool {
        return true
    }
    
    var countdownColor: UIColor {
        return .black
    }
    
    override var prefersStatusBarHidden: Bool {
        return fullSizeConstraints.first?.isActive == true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        titleLabel.text = NSLocalizedString("Tap Task Title", comment: "") + " (25 之 1)"
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        primaryButton.setTitle("Start Trial", for: .normal)
        primaryButton.setTitleColor(.white, for: .normal)
        primaryButton.setBackgroundImage(UIImage.primaryButtonBackgroundImage(color: view.tintColor), for: .normal)
        primaryButton.addTarget(self, action: #selector(handlePrimaryButton(_:)), for: .touchUpInside)
        
        secondaryButton.setTitle("Try Again", for: .normal)
        secondaryButton.titleLabel?.font = primaryButton.titleLabel?.font
        secondaryButton.setBackgroundImage(UIImage.secondaryButtonBackgroundImage(color: view.tintColor), for: .normal)
        secondaryButton.addTarget(self, action: #selector(handleSecondaryButton(_:)), for: .touchUpInside)
        secondaryButton.isHidden = true
        
        cancelButton.setTitle(NSLocalizedString("Withdraw Exam", comment: ""), for: .normal)
        cancelButton.addTarget(self, action: #selector(handleCancelButton(_:)), for: .touchUpInside)
        
        trialView.delegate = self
        
        previewBorderView.layer.borderColor = UIColor.black.cgColor
        previewBorderView.layer.borderWidth = 2.0
        previewBorderView.layer.cornerRadius = 4.0
        
        whiteView.backgroundColor = .white
        whiteView.alpha = 0.0
        
        maskView.alpha = 0.0
        
        countDownView.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        countDownView.alpha = 0.0
        countDownView.label.textColor = countdownColor
        
        view.addSubview(titleLabel)
        view.addSubview(buttonStack)
        view.addSubview(cancelButton)
        view.addSubview(previewBorderView)
        view.addSubview(whiteView)
        view.addSubview(maskView)
        view.addSubview(trialView)
        view.addSubview(countDownView)
        
        view.addLayoutGuide(previewLayoutGuide)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        previewBorderView.translatesAutoresizingMaskIntoConstraints = false
        whiteView.translatesAutoresizingMaskIntoConstraints = false
        maskView.translatesAutoresizingMaskIntoConstraints = false
        trialView.translatesAutoresizingMaskIntoConstraints = false
        countDownView.translatesAutoresizingMaskIntoConstraints = false
        
        previewConstraints = [
            trialView.centerXAnchor.constraint(equalTo: previewLayoutGuide.centerXAnchor),
            trialView.centerYAnchor.constraint(equalTo: previewLayoutGuide.centerYAnchor),
            trialView.widthAnchor.constraint(equalTo: view.widthAnchor),
            trialView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ]
        
        fullSizeConstraints = [
            trialView.topAnchor.constraint(equalTo: view.topAnchor),
            trialView.leftAnchor.constraint(equalTo: view.leftAnchor),
            trialView.rightAnchor.constraint(equalTo: view.rightAnchor),
            trialView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            cancelButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            buttonStack.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -20),
            buttonStack.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            buttonStack.widthAnchor.constraint(equalToConstant: 343),
            buttonStack.heightAnchor.constraint(equalToConstant: 50),
            
            previewLayoutGuide.topAnchor.constraintEqualToSystemSpacingBelow(titleLabel.topAnchor, multiplier: 2.0),
            previewLayoutGuide.leftAnchor.constraint(equalTo: view.leftAnchor),
            previewLayoutGuide.rightAnchor.constraint(equalTo: view.rightAnchor),
            buttonStack.topAnchor.constraintEqualToSystemSpacingBelow(previewLayoutGuide.bottomAnchor, multiplier: 1.0),
            
            previewBorderView.centerXAnchor.constraint(equalTo: previewLayoutGuide.centerXAnchor),
            previewBorderView.centerYAnchor.constraint(equalTo: previewLayoutGuide.centerYAnchor),
            previewBorderView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: previewScale + 0.05),
            previewBorderView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: previewScale + 0.05),
            
            whiteView.topAnchor.constraint(equalTo: view.topAnchor),
            whiteView.leftAnchor.constraint(equalTo: view.leftAnchor),
            whiteView.rightAnchor.constraint(equalTo: view.rightAnchor),
            whiteView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            maskView.topAnchor.constraint(equalTo: view.topAnchor),
            maskView.leftAnchor.constraint(equalTo: view.leftAnchor),
            maskView.rightAnchor.constraint(equalTo: view.rightAnchor),
            maskView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            countDownView.topAnchor.constraint(equalTo: view.topAnchor),
            countDownView.leftAnchor.constraint(equalTo: view.leftAnchor),
            countDownView.rightAnchor.constraint(equalTo: view.rightAnchor),
            countDownView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate(previewConstraints)
        trialView.transform = CGAffineTransform(scaleX: previewScale, y: previewScale)
    }
    
    @objc private func handlePrimaryButton(_ sender: UIButton) {
        primaryButtonDidSelect()
    }
    
    @objc private func handleSecondaryButton(_ sender: UIButton) {
        secondaryButtonDidSelect()
    }
    
    @objc private func handleCancelButton(_ sender: UIButton) {
        cancelButtonDidSelect()
    }
    
    func primaryButtonDidSelect() {
        if shouldStartTrialAutomaticallyOnPrimaryButtonTapped {
            startTrial()
        }
    }
    
    func secondaryButtonDidSelect() {
        // no-op
    }
    
    func cancelButtonDidSelect() {
        
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
    
    func willStartTrial() {
        
    }
    
    func startTrial() {
        
        willStartTrial()
        
        NSLayoutConstraint.deactivate(previewConstraints)
        NSLayoutConstraint.activate(fullSizeConstraints)
        
        setNeedsStatusBarAppearanceUpdate()
        
        UIView.animate(withDuration: 0.325, delay: 0.0, options: [.curveEaseInOut], animations: {
            
            self.trialView.transform = .identity
            self.maskView.alpha = 1.0
            self.countDownView.alpha = 1.0
            
            self.view.layoutIfNeeded()
            
        }, completion: { _ in
            
            self.whiteView.alpha = 1.0
            self.maskView.alpha = 0.0
            
            self.countDownView.fire {
                self.countDownView.alpha = 0.0
                
                self.trialStartDate = Date()
                self.didStartTrial()
            }
            
        })
    }
    
    func didStartTrial() {
        self.trialView.startTracking()
    }
    
    func willEndTrial() {
        self.trialView.stopTracking()
    }
    
    func endTrial() {
        
        willEndTrial()
        trialEndDate = Date()
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseInOut], animations: {
            
            self.trialView.alpha = 0.0
            
        }, completion: { _ in
            
            NSLayoutConstraint.deactivate(self.fullSizeConstraints)
            NSLayoutConstraint.activate(self.previewConstraints)
            
            self.setNeedsStatusBarAppearanceUpdate()
            
            self.trialView.transform = CGAffineTransform(scaleX: previewScale, y: previewScale)
            self.trialView.alpha = 1.0
            self.whiteView.alpha = 0.0
            
            self.didEndTrial()
        })
    }
    
    func didEndTrial() {
        
    }
    
    func presentNextViewController() {
        
        if let taskViewController = nextViewController() {
            taskViewController.taskResultManager = taskResultManager
            navigationController?.pushViewController(taskViewController, animated: true)
        }
    }
}

extension TaskTrialViewController: TouchTrackingViewDelegate {
    
    func touchTrackingViewDidCompleteNewTracks(_ touchTrackingView: TouchTrackingView) {
        endTrial()
    }
}
