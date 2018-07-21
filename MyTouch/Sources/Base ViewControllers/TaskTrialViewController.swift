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

    
    // MARK: - UI Properties
    
    lazy var cancelButton: UIBarButtonItem = {
        return UIBarButtonItem(title: NSLocalizedString("CANCEL_TASK_BUTTON", comment: ""), style: .plain, target: self, action: #selector(dismissTaskWithConfimation))
    }()
    
    lazy var nextButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: NSLocalizedString("NEXT_BUTTON", comment: ""), style: .plain, target: self, action: #selector(presentNext))
        button.isEnabled = self.prefersNextButtonEnabled()
        return button
    }()
    
    let instructionLabel = UILabel()
    let actionButton     = UIButton(type: .custom)
    let countDownView    = CountdownView()
    
    lazy private(set) var _trialView: (UIView & TrialViewProtocol) = {
        let view = self.trialView()
        view.isUserInteractionEnabled = false
        view.touchTrackingDelegate = self
        return view
    }()
    
    private let trialDidEndView   = UIView()
    private let previewBorderView = UIView()
    
    // layout assists
    private let previewLayoutGuide  = UILayoutGuide()
    private var previewConstraints  = [NSLayoutConstraint]()
    private var fullSizeConstraints = [NSLayoutConstraint]()
    
    // trial times
    private(set) var trialStartDate:    Date = .distantPast
    private(set) var trialEndDate:      Date = .distantFuture
    private(set) var lastTouchesUpDate: Date?
    
    
    // MARK: - TaskViewController
    
    override func nextViewController() -> TaskViewController? {
        return TaskEndViewController()
    }
    
    
    // MARK: - UIViewController
    
    override var prefersStatusBarHidden: Bool {
        if let constraint = fullSizeConstraints.first {
            return constraint.isActive
        } else {
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        title = NSLocalizedString("Tap Task Title", comment: "") + " (1/25)"
        
        navigationItem.leftBarButtonItem  = cancelButton
        navigationItem.rightBarButtonItem = nextButton
        
        instructionLabel.text = NSLocalizedString("Tap Task Title", comment: "")
        instructionLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        instructionLabel.numberOfLines = 0
        instructionLabel.lineBreakMode = .byWordWrapping
        instructionLabel.textAlignment = .center
        
        actionButton.setTitle("Start Trial", for: .normal)
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.setBackgroundImage(UIImage.primaryButtonBackgroundImage(color: view.tintColor), for: .normal)
        actionButton.addTarget(self, action: #selector(handleButton(_:)), for: .touchUpInside)
        
        previewBorderView.layer.borderColor = UIColor.lightGray.cgColor
        previewBorderView.layer.borderWidth = 2.0
        previewBorderView.layer.cornerRadius = 4.0

        view.addSubview(instructionLabel)
        view.addSubview(actionButton)
        view.addSubview(previewBorderView)
        view.addSubview(_trialView)
        view.addLayoutGuide(previewLayoutGuide)
        
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        previewBorderView.translatesAutoresizingMaskIntoConstraints = false
        _trialView.translatesAutoresizingMaskIntoConstraints = false
        
        previewConstraints = [
            _trialView.centerXAnchor.constraint(equalTo: previewLayoutGuide.centerXAnchor),
            _trialView.centerYAnchor.constraint(equalTo: previewLayoutGuide.centerYAnchor),
            _trialView.widthAnchor.constraint(equalTo: view.widthAnchor),
            _trialView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ]
        
        fullSizeConstraints = [
            _trialView.topAnchor.constraint(equalTo: view.topAnchor),
            _trialView.leftAnchor.constraint(equalTo: view.leftAnchor),
            _trialView.rightAnchor.constraint(equalTo: view.rightAnchor),
            _trialView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate([
            
            instructionLabel.topAnchor.constraintEqualToSystemSpacingBelow(view.safeAreaLayoutGuide.topAnchor, multiplier: 5.0),
            instructionLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            instructionLabel.leftAnchor.constraint(equalTo: view.readableContentGuide.leftAnchor),
            instructionLabel.rightAnchor.constraint(equalTo: view.readableContentGuide.rightAnchor),
            
            previewLayoutGuide.topAnchor.constraintEqualToSystemSpacingBelow(instructionLabel.topAnchor, multiplier: 5.0),
            previewLayoutGuide.leftAnchor.constraint(equalTo: view.leftAnchor),
            previewLayoutGuide.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            previewBorderView.centerXAnchor.constraint(equalTo: previewLayoutGuide.centerXAnchor),
            previewBorderView.centerYAnchor.constraint(equalTo: previewLayoutGuide.centerYAnchor),
            previewBorderView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: previewScale + 0.01),
            previewBorderView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: previewScale + 0.01),
            
            actionButton.topAnchor.constraintEqualToSystemSpacingBelow(previewLayoutGuide.bottomAnchor, multiplier: 5.0),
            actionButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 343),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
            
            view.bottomAnchor.constraintEqualToSystemSpacingBelow(actionButton.bottomAnchor, multiplier: 5.0)
        ])
        
        countDownView.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        countDownView.label.textColor = .black
        countDownView.isHidden = true

        trialDidEndView.backgroundColor = .white
        trialDidEndView.isHidden = true
        
        view.addSubview(countDownView)
        view.addSubview(trialDidEndView)
        
        countDownView.translatesAutoresizingMaskIntoConstraints = false
        trialDidEndView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            countDownView.topAnchor.constraint(equalTo: view.topAnchor),
            countDownView.leftAnchor.constraint(equalTo: view.leftAnchor),
            countDownView.rightAnchor.constraint(equalTo: view.rightAnchor),
            countDownView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            trialDidEndView.topAnchor.constraint(equalTo: view.topAnchor),
            trialDidEndView.leftAnchor.constraint(equalTo: view.leftAnchor),
            trialDidEndView.rightAnchor.constraint(equalTo: view.rightAnchor),
            trialDidEndView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate(previewConstraints)
        _trialView.transform = CGAffineTransform(scaleX: previewScale, y: previewScale)
    }
    
    
    // MARK: - UI Event Handlers
    
    @objc private func handleButton(_ sender: UIButton) {
        startTrial()
    }
    
    
    // MARK: - Methods
    
    func shouldStartTrial() -> Bool { return true }
    
    func willStartTrial() {
        lastTouchesUpDate = nil
        
        if let isBarHidden = navigationController?.isNavigationBarHidden, !isBarHidden {
            navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    
    final func startTrial() {
        
        guard shouldStartTrial() else { return }
        
        willStartTrial()
        
        NSLayoutConstraint.deactivate(previewConstraints)
        NSLayoutConstraint.activate(fullSizeConstraints)
        
        setNeedsStatusBarAppearanceUpdate()
        
        countDownView.isHidden = false
        countDownView.alpha = 0.0
        
        UIView.animate(withDuration: 0.325, delay: 0.0, options: [.curveEaseInOut], animations: {
            
            self._trialView.transform = .identity
            self.countDownView.alpha = 1.0
            
            self.view.layoutIfNeeded()
            
        }, completion: { _ in
            
            self.countDownView.fire {
                
                self.countDownView.alpha = 0.0
                self.countDownView.isHidden = true
                
                self.didStartTrial()
            }
        })
    }
    
    func didStartTrial() {
        _trialView.isUserInteractionEnabled = true
        trialStartDate = Date()
        _trialView.startTracking()
    }
    
    func shouldEndTrial() -> Bool { return true }
    
    func willEndTrial() {}
    
    final func endTrial() {
        
        guard shouldEndTrial() else { return }
        
        willEndTrial()
        
        NSLayoutConstraint.deactivate(fullSizeConstraints)
        NSLayoutConstraint.activate(previewConstraints)
        
        setNeedsStatusBarAppearanceUpdate()
        
        _trialView.transform = CGAffineTransform(scaleX: previewScale, y: previewScale)
        trialDidEndView.isHidden = true
        
        didEndTrial()
    }
    
    func didEndTrial() {
        
        trialEndDate = Date()
        _trialView.stopTracking()
        _trialView.isUserInteractionEnabled = false
        
        if let isBarHidden = navigationController?.isNavigationBarHidden, isBarHidden {
            navigationController?.setNavigationBarHidden(false, animated: false)
        }
        
        nextButton.isEnabled = prefersNextButtonEnabled()
    }
    
    func trialView() -> (UIView & TrialViewProtocol) {
        return TrialView()
    }
    
    func prefersNextButtonEnabled() -> Bool {
        return true
    }
}

// MARK: - TouchTrackingViewDelegate
extension TaskTrialViewController: TouchTrackingViewDelegate {
    
    func touchTrackingViewDidBeginNewTrack(_ touchTrackingView: TouchTrackingViewProtocol) {
        
        // has complete new tracks, update touches up date
        if lastTouchesUpDate != nil {
            lastTouchesUpDate = Date()
        }
    }
    
    func touchTrackingViewDidCompleteNewTracks(_ touchTrackingView: TouchTrackingViewProtocol) {
        
        // dismiss content views by masking a white view
        // only run the animation on first time
        if lastTouchesUpDate == nil {
            
            trialDidEndView.isHidden = false
            trialDidEndView.alpha = 0.0
            
            UIView.animate(withDuration: 0.2) {
                self.trialDidEndView.alpha = 1.0
            }
        }
        
        lastTouchesUpDate = Date()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [lastTouchesUpDate = self.lastTouchesUpDate] in
            
            if lastTouchesUpDate == self.lastTouchesUpDate {
                self.endTrial()
            }
        }
    }
}
