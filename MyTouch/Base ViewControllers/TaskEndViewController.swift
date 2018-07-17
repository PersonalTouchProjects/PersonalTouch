//
//  TrialEndViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/1.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TaskEndViewController: UIViewController, TaskResultManagerViewController {

    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    
    let primaryButton = UIButton(type: .custom)
    let cancelButton = UIButton(type: .system)
    
    var taskResultManager: TaskResultManager?
    
    func nextViewController() -> (UIViewController & TaskResultManagerViewController)? {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        titleLabel.text = NSLocalizedString("Tap Task End Title", comment: "")
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        descriptionLabel.text = NSLocalizedString("Tap Task Description", comment: "")
        descriptionLabel.font = UIFont.systemFont(ofSize: 28, weight: .light)
        
        primaryButton.setTitle(NSLocalizedString("Start Exam", comment: ""), for: .normal)
        primaryButton.setTitleColor(.white, for: .normal)
        primaryButton.setBackgroundImage(UIImage.primaryButtonBackgroundImage(color: view.tintColor), for: .normal)
        primaryButton.addTarget(self, action: #selector(handlePrimaryButton(_:)), for: .touchUpInside)
        
        cancelButton.setTitle(NSLocalizedString("Start Exam", comment: ""), for: .normal)
        cancelButton.addTarget(self, action: #selector(handleCancelButton(_:)), for: .touchUpInside)
        
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(primaryButton)
        view.addSubview(cancelButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        primaryButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            cancelButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            primaryButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -20),
            primaryButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            primaryButton.widthAnchor.constraint(equalToConstant: 343),
            primaryButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func handlePrimaryButton(_ sender: UIButton) {
        primaryButtonDidSelect()
    }
    
    @objc private func handleCancelButton(_ sender: UIButton) {
        cancelButtonDidSelect()
    }
    
    func primaryButtonDidSelect() {
        
        do {
            try taskResultManager?.session.archive()
        } catch {
            print("archive error: \(error)")
        }
        
        if let taskViewController = nextViewController() {
            taskViewController.taskResultManager = taskResultManager
            navigationController?.pushViewController(taskViewController, animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func cancelButtonDidSelect() {
        
    }

}
