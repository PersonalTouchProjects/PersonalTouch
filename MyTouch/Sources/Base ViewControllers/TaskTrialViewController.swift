//
//  TrialViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/1.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

private var previewScale: CGFloat = 0.5

class TaskTrialViewController: TaskViewController {

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
    
    var trialView: (UIView & TrialViewProtocol) = TrialView()
    
    private let maskView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private let trialDidEndView = UIView()
    private let previewBorderView = UIView()
    private let countDownView = CountdownView()
    
    private let previewLayoutGuide = UILayoutGuide()
    private var previewConstraints = [NSLayoutConstraint]()
    private var fullSizeConstraints = [NSLayoutConstraint]()
    
    private(set) var trialStartDate = Date.distantPast
    private(set) var trialEndDate = Date.distantFuture
    
    private(set) var lastTouchesUpDate: Date?
    

    override func nextViewController() -> TaskViewController? {
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
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var keyCommands: [UIKeyCommand]? {
        return [
            UIKeyCommand(input: "\r", modifierFlags: [], action: #selector(handleKeyboardWhitespace(_:)), discoverabilityTitle: "Start Trial"),
            UIKeyCommand(input: " ", modifierFlags: [], action: #selector(handleKeyboardWhitespace(_:)), discoverabilityTitle: "Start Trial"),
            UIKeyCommand(input: UIKeyInputEscape, modifierFlags: [], action: #selector(handleKeyboardEscape(_:)), discoverabilityTitle: "End Trial")
        ]
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
        
        trialView.touchTrackingDelegate = self
        
        previewBorderView.layer.borderColor = UIColor.black.cgColor
        previewBorderView.layer.borderWidth = 2.0
        previewBorderView.layer.cornerRadius = 4.0
        
        trialDidEndView.backgroundColor = .white
        trialDidEndView.isHidden = true
        
        maskView.alpha = 0.0
        
        countDownView.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        countDownView.alpha = 0.0
        countDownView.label.textColor = countdownColor
        
        view.addSubview(titleLabel)
        view.addSubview(buttonStack)
        view.addSubview(cancelButton)
        view.addSubview(previewBorderView)
        view.addSubview(maskView)
        view.addSubview(trialView)
        view.addSubview(countDownView)
        view.addSubview(trialDidEndView)
        
        view.addLayoutGuide(previewLayoutGuide)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        previewBorderView.translatesAutoresizingMaskIntoConstraints = false
        trialDidEndView.translatesAutoresizingMaskIntoConstraints = false
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
            
            trialDidEndView.topAnchor.constraint(equalTo: view.topAnchor),
            trialDidEndView.leftAnchor.constraint(equalTo: view.leftAnchor),
            trialDidEndView.rightAnchor.constraint(equalTo: view.rightAnchor),
            trialDidEndView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
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
    
    // MARK: - UI Event Handlers
    
    @objc private func handlePrimaryButton(_ sender: UIButton) {
        primaryButtonDidSelect()
    }
    
    @objc private func handleSecondaryButton(_ sender: UIButton) {
        secondaryButtonDidSelect()
    }
    
    @objc private func handleCancelButton(_ sender: UIButton) {
        cancelButtonDidSelect()
    }
    
    @objc private func handleKeyboardWhitespace(_ sender: UIKeyCommand) {
        if previewConstraints.first?.isActive == true {
            startTrial()
        }
    }
    
    @objc private func handleKeyboardEscape(_ sender: UIKeyCommand) {
        if fullSizeConstraints.first?.isActive == true {
            endTrial()
        }
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
    
    
    // MARK: - Trial Life Cycle
    
    func willStartTrial() {
        self.lastTouchesUpDate = nil
        // navigationController?.setNavigationBarHidden(true, animated: true)
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
            
            self.maskView.alpha = 0.0
            
            self.countDownView.fire {
                self.countDownView.alpha = 0.0
                
                self.trialStartDate = Date()
                self.didStartTrial()
            }
            
        })
    }
    
    func didStartTrial() {
        self.trialView.isUserInteractionEnabled = true
        self.trialView.startTracking()
    }
    
    func willEndTrial() {
        
    }
    
    func endTrial() {
        
        willEndTrial()
        trialEndDate = Date()
        
        NSLayoutConstraint.deactivate(self.fullSizeConstraints)
        NSLayoutConstraint.activate(self.previewConstraints)
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        self.trialView.transform = CGAffineTransform(scaleX: previewScale, y: previewScale)
        self.trialDidEndView.isHidden = true
        
        self.didEndTrial()
    }
    
    func didEndTrial() {
        self.trialView.stopTracking()
        self.trialView.isUserInteractionEnabled = false
        // navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func presentNextViewController() {
        
        if let taskViewController = nextViewController() {
            taskViewController.taskResultManager = taskResultManager
            navigationController?.pushViewController(taskViewController, animated: true)
        }
    }
}

// MARK: - TouchTrackingViewDelegate
extension TaskTrialViewController: TouchTrackingViewDelegate {
    
    func touchTrackingViewDidBeginNewTrack(_ touchTrackingView: TouchTrackingViewProtocol) {
        
        // has complete new tracks, update touches up date
        if self.lastTouchesUpDate != nil {
            self.lastTouchesUpDate = Date()
        }
    }
    
    func touchTrackingViewDidCompleteNewTracks(_ touchTrackingView: TouchTrackingViewProtocol) {
        
        // dismiss content views by masking a white view
        // only run the animation on first time
        if self.lastTouchesUpDate == nil {
            
            self.trialDidEndView.isHidden = false
            self.trialDidEndView.alpha = 0.0
            UIView.animate(withDuration: 0.2) {
                self.trialDidEndView.alpha = 1.0
            }
        }
        
        self.lastTouchesUpDate = Date()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [lastTouchesUpDate = self.lastTouchesUpDate] in
            
            if lastTouchesUpDate == self.lastTouchesUpDate {
                self.endTrial()
            }
        }
    }
}
