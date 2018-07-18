//
//  HomeViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/29.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    let descriptionLabel = UILabel()
    let startExamButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Exam", comment: "")
        
        view.backgroundColor = .white
        
        descriptionLabel.text = NSLocalizedString("Exam Description", comment: "")
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.textAlignment = .center
        
        startExamButton.setTitle(NSLocalizedString("Start Exam", comment: ""), for: .normal)
        startExamButton.setTitleColor(.white, for: .normal)
        startExamButton.setBackgroundImage(UIImage.primaryButtonBackgroundImage(color: view.tintColor), for: .normal)
        startExamButton.addTarget(self, action: #selector(handleButton(_:)), for: .touchUpInside)
        
        view.addSubview(descriptionLabel)
        view.addSubview(startExamButton)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        startExamButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.leftAnchor.constraint(equalTo: view.readableContentGuide.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: view.readableContentGuide.rightAnchor),
            
            startExamButton.widthAnchor.constraint(equalToConstant: 343),
            startExamButton.heightAnchor.constraint(equalToConstant: 50),
            startExamButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startExamButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        ])
    }
    
    @objc func handleButton(_ sender: UIButton) {
        
//        let taskViewController = TapTaskTrialViewController()
        let taskViewController = SwipeTaskInstructionViewController()
        taskViewController.taskResultManager = TaskResultManager(session: Session())
        let navController = UINavigationController(rootViewController: taskViewController)
        navController.setNavigationBarHidden(true, animated: false)
        navController.modalTransitionStyle = .flipHorizontal
        
        present(navController, animated: true, completion: nil)
    }
}
