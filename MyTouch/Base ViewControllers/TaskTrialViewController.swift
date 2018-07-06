//
//  TrialViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/1.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

private var previewScale: CGFloat = 0.5

class TaskTrialViewController: UIViewController {

    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let actionButton = UIButton(type: .custom)
    let cancelButton = UIButton(type: .system)
    
    var trialView: TrialView = TrialView()
    let maskView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let previewBorderView = UIView()
    let countDownView = CountdownView()
    
    private let previewLayoutGuide = UILayoutGuide()
    private var previewConstraints = [NSLayoutConstraint]()
    private var fullSizeConstraints = [NSLayoutConstraint]()
    
    private(set) var trialStartDate = Date.distantPast
    private(set) var trialEndDate = Date.distantFuture
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        titleLabel.text = NSLocalizedString("Tap Task Title", comment: "")
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        descriptionLabel.text = NSLocalizedString("Tap Task Description", comment: "")
        descriptionLabel.font = UIFont.systemFont(ofSize: 28, weight: .light)
        
        actionButton.setTitle("Start Trial", for: .normal)
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.setBackgroundImage(UIImage.buttonBackgroundImage(color: view.tintColor), for: .normal)
        actionButton.addTarget(self, action: #selector(handleActionButton(_:)), for: .touchUpInside)
        
        cancelButton.setTitle(NSLocalizedString("Withdraw Exam", comment: ""), for: .normal)
        cancelButton.addTarget(self, action: #selector(handleCancelButton(_:)), for: .touchUpInside)
        
        trialView.delegate = self
        
        previewBorderView.layer.borderColor = UIColor.black.cgColor
        previewBorderView.layer.borderWidth = 2.0
        previewBorderView.layer.cornerRadius = 4.0
        
        maskView.alpha = 0.0
        
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(actionButton)
        view.addSubview(cancelButton)
        view.addSubview(previewBorderView)
        view.addSubview(maskView)
        view.addSubview(trialView)
        view.addLayoutGuide(previewLayoutGuide)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        previewBorderView.translatesAutoresizingMaskIntoConstraints = false
        maskView.translatesAutoresizingMaskIntoConstraints = false
        trialView.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            cancelButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            actionButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -20),
            actionButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 343),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
            
            previewLayoutGuide.topAnchor.constraintEqualToSystemSpacingBelow(descriptionLabel.topAnchor, multiplier: 2.0),
            previewLayoutGuide.leftAnchor.constraint(equalTo: view.leftAnchor),
            previewLayoutGuide.rightAnchor.constraint(equalTo: view.rightAnchor),
            actionButton.topAnchor.constraintEqualToSystemSpacingBelow(previewLayoutGuide.bottomAnchor, multiplier: 1.0),
            
            previewBorderView.centerXAnchor.constraint(equalTo: previewLayoutGuide.centerXAnchor),
            previewBorderView.centerYAnchor.constraint(equalTo: previewLayoutGuide.centerYAnchor),
            previewBorderView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: previewScale + 0.05),
            previewBorderView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: previewScale + 0.05),
            
            maskView.topAnchor.constraint(equalTo: view.topAnchor),
            maskView.leftAnchor.constraint(equalTo: view.leftAnchor),
            maskView.rightAnchor.constraint(equalTo: view.rightAnchor),
            maskView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate(previewConstraints)
        trialView.transform = CGAffineTransform(scaleX: previewScale, y: previewScale)
    }
    
    @objc private func handleActionButton(_ sender: UIButton) {
        actionButtonDidSelect()
    }
    
    @objc private func handleCancelButton(_ sender: UIButton) {
        cancelButtonDidSelect()
    }
    
    func actionButtonDidSelect() {
        
        NSLayoutConstraint.deactivate(previewConstraints)
        NSLayoutConstraint.activate(fullSizeConstraints)
        
        UIView.animate(withDuration: 0.325, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.trialView.transform = .identity
            self.maskView.alpha = 1.0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.trialView.startTracking()
        })
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
}

extension TaskTrialViewController: TouchTrackingViewDelegate {
    
    func touchTrackingViewDidCompleteNewTracks(_ touchTrackingView: TouchTrackingView) {
        
        self.trialView.stopTracking()
        
        NSLayoutConstraint.deactivate(fullSizeConstraints)
        NSLayoutConstraint.activate(previewConstraints)

        UIView.animate(withDuration: 0.325, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.trialView.transform = CGAffineTransform(scaleX: previewScale, y: previewScale)
            self.maskView.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
