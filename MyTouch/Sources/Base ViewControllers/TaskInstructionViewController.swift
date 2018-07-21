//
//  TaskInstructionViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/6.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TaskInstructionViewController: TaskViewController {

    let instructionLabel = UILabel()
    let contentView      = UIView()
    
    // MARK: - TaskViewController
    
    override func nextViewController() -> TaskViewController? {
        return TaskTrialViewController()
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        title = NSLocalizedString( "TASK_INSTRUCTION_TITLE", comment: "")
        
        navigationItem.leftBarButtonItem  = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissTask))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("NEXT_BUTTON", comment: ""), style: .plain, target: self, action: #selector(presentNext))
        
        instructionLabel.text = NSLocalizedString("TASK_INSTRUCTION", comment: "")
        instructionLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        instructionLabel.numberOfLines = 0
        instructionLabel.lineBreakMode = .byWordWrapping
        instructionLabel.textAlignment = .center
        
        view.addSubview(instructionLabel)
        view.addSubview(contentView)
        
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraintEqualToSystemSpacingBelow(view.safeAreaLayoutGuide.topAnchor, multiplier: 5.0),
            instructionLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            instructionLabel.leftAnchor.constraint(equalTo: view.readableContentGuide.leftAnchor),
            instructionLabel.rightAnchor.constraint(equalTo: view.readableContentGuide.rightAnchor),
            
            contentView.topAnchor.constraintEqualToSystemSpacingBelow(instructionLabel.bottomAnchor, multiplier: 5.0),
            contentView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            contentView.leftAnchor.constraint(equalTo: view.readableContentGuide.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: view.readableContentGuide.rightAnchor),
            
            view.bottomAnchor.constraintEqualToSystemSpacingBelow(contentView.bottomAnchor, multiplier: 1.0)
        ])
    }
    
    // MARK: - UI Event Handlers
    
//    @objc private func handleCancelButton(_ sender: UIBarButtonItem) {
//        dismissTask()
//    }
//
//    @objc private func handleNextButton(_ sender: UIBarButtonItem) {
//        presentNext()
//    }
//
//    func cancelButtonDidSelect() {
//        dismissTask()
//    }
//    
//    func nextButtonDidSelect() {
//        presentNext()
//    }
}
