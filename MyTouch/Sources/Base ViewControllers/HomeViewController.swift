//
//  HomeViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/29.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit
import ResearchKit

class HomeViewController: UIViewController {
    
    let descriptionLabel = UILabel()
    let startExamButton = UIButton(type: .custom)
    
    enum State {
        case home
        case consent
        case survey
    }
    
    private var state = State.home
    
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
        
        presentTaskColleciton()
        
//        presentConsent()
    }
    
    private func presentTaskColleciton() {
        let taskCollectionViewController = TaskCollectionViewController()
        let navController = UINavigationController(rootViewController: taskCollectionViewController)
        
        present(navController, animated: true) {}
    }
    
    private func presentConsent() {
        
        let taskViewController = ORKTaskViewController(task: ConsentTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true) {
            self.state = .consent
        }
    }
    
    private func presentSurvey() {
        
        let taskViewController = ORKTaskViewController(task: Research.survey, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true) {
            self.state = .survey
        }
    }
    
    private func presentTasks() {
        
        func presentTaskViewController(_ vc: TaskViewController) {
            
            vc.taskResultManager = TaskResultManager(session: Session())
            
            let navController = UINavigationController(rootViewController: vc)
            navController.modalTransitionStyle = .flipHorizontal
            
            self.present(navController, animated: true) {
                self.state = .home
            }
        }
        
        // present alert controller
        let alert = UIAlertController(title: "測驗", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "點擊", style: .default) { _ in
            presentTaskViewController(TapTaskInstructionViewController())
        })
        alert.addAction(UIAlertAction(title: "掃動", style: .default) { _ in
            presentTaskViewController(SwipeTaskInstructionViewController())
        })
        alert.addAction(UIAlertAction(title: "拖拉放", style: .default) { _ in
            presentTaskViewController(DragAndDropTaskInstructionViewController())
        })
        alert.addAction(UIAlertAction(title: "滾動", style: .default) { _ in
            presentTaskViewController(ScrollTaskInstructionViewController())
        })
        alert.addAction(UIAlertAction(title: "縮放", style: .default) { _ in
            presentTaskViewController(PinchTaskInstructionViewController())
        })
        alert.addAction(UIAlertAction(title: "旋轉", style: .default) { _ in
            presentTaskViewController(RotationTaskInstructionViewController())
        })
        alert.addAction(UIAlertAction(title: "測試", style: .default) { _ in
            presentTaskViewController(TaskInstructionViewController())
        })
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        
        alert.popoverPresentationController?.sourceView = view
        alert.popoverPresentationController?.sourceRect = startExamButton.frame
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension HomeViewController: ORKTaskViewControllerDelegate {
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
        // print(taskViewController.result.results)
        
        taskViewController.dismiss(animated: true) {
            
            switch self.state {
            case .consent: self.presentSurvey()
            case .survey:  self.presentTasks()
            default: break
            }
        }
        
    }
    
}
