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
        
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
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
        
//        presentTaskColleciton()
//        presentConsent()
        presentSurvey()
    }
    
    private func presentTaskColleciton() {
        let taskCollectionViewController = TaskCollectionViewController()
        let navController = UINavigationController(rootViewController: taskCollectionViewController)
        
        present(navController, animated: true) {
            self.state = .home
        }
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
    
}

extension HomeViewController: ORKTaskViewControllerDelegate {
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
        // print(taskViewController.result.results)
        
        taskViewController.dismiss(animated: true) {
            
            if reason == .completed {
                switch self.state {
                case .consent:
                    self.presentSurvey()
                    
                case .survey:
                    let session = Session()
                    session.participant = Participant(id: 1234, name: "Tommy Lin", birthYear: 1991, gender: .male, dominantHand: .left, note: "")
                    
                    SessionManager.shared.currentSession = session
                    self.presentTaskColleciton()
                default: break
                }
            }
        }
    }
    
}
