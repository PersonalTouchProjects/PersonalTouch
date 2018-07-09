//
//  HomeViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/29.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit
import ResearchKit

class HomeViewController: UIViewController, ORKTaskViewControllerDelegate {
    
    let descriptionLabel = UILabel()
    let startExamButton = UIButton(type: .custom)
    
    var taskResult: ORKTaskResult!
    var taskResults: [ORKTaskResult] = [] // need to initialize
    var taskState: String!

    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {

        taskResult = taskViewController.result
        taskResults.append(taskResult)
        taskViewController.dismiss(animated: true, completion: nil)

        if (taskState == "ConsentTask") {
            let taskViewController = ORKTaskViewController(task: SurveyTask, taskRun: nil)
            taskViewController.delegate = self
            taskState = "SurveyTask"
            present(taskViewController, animated: true, completion: nil)
        }
//
        else if (taskState == "SurveyTask") {
            // things should be done after survey
//            let taskViewController = ORKTaskViewController(task: ActiveTask, taskRun: nil)
//            taskViewController.delegate = self
//            taskState = "ActiveTask"
//            present(taskViewController, animated: true, completion: nil)

            let taskViewController = TaskInstructionViewController()
            let navController = UINavigationController(rootViewController: taskViewController)
            navController.setNavigationBarHidden(true, animated: false)
            navController.modalTransitionStyle = .flipHorizontal

            present(navController, animated: true, completion: nil)

        }

//                else if (taskState == "ActiveTask") {
//                     // things should be done after survey
//                      print (taskResults)
//                }


    }

    
    
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
        startExamButton.setBackgroundImage(UIImage.buttonBackgroundImage(color: view.tintColor), for: .normal)
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

        let taskViewController = ORKTaskViewController(task: ConsentTask, taskRun: nil)
        taskViewController.delegate = self
        taskState = "ConsentTask"
        present(taskViewController, animated: true, completion: nil)

    }
    
    
//    @objc func handleButton(_ sender: UIButton) {
//
////        let taskViewController = TapTaskTrialViewController()
//        let taskViewController = TaskInstructionViewController()
//        let navController = UINavigationController(rootViewController: taskViewController)
//        navController.setNavigationBarHidden(true, animated: false)
//        navController.modalTransitionStyle = .flipHorizontal
//
//        present(navController, animated: true, completion: nil)
//    }
    
    
}
