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

        title = "實驗"
        navigationItem.title = "MyTouch 觸控螢幕實驗"
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        let description = """
        以下我們會進行幾項測驗
        每項測驗中有10-30個必須完成的任務
        每個任務間可自由調配時間休息
        如果沒有問題
        請點擊開始測驗
        我們的測驗便會正式開始
        """
        
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.2
        style.lineBreakMode = .byWordWrapping
        style.alignment = .center
        
        let attrs = [
            NSAttributedStringKey.paragraphStyle: style,
            NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .largeTitle)
        ]
        
        descriptionLabel.attributedText = NSAttributedString(string: description, attributes: attrs)
        descriptionLabel.numberOfLines = 0
        
        startExamButton.setTitle("開始測驗", for: .normal)
        startExamButton.setTitleColor(.white, for: .normal)
        startExamButton.setBackgroundImage(UIImage.primaryButtonBackgroundImage(color: view.tintColor), for: .normal)
        startExamButton.addTarget(self, action: #selector(handleButton(_:)), for: .touchUpInside)
        
        view.addSubview(descriptionLabel)
        view.addSubview(startExamButton)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        startExamButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraintEqualToSystemSpacingBelow(view.safeAreaLayoutGuide.topAnchor, multiplier: 1.0),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.leftAnchor.constraint(equalTo: view.readableContentGuide.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: view.readableContentGuide.rightAnchor),
            
            startExamButton.topAnchor.constraintEqualToSystemSpacingBelow(descriptionLabel.bottomAnchor, multiplier: 1.0),
            startExamButton.widthAnchor.constraint(equalToConstant: 343),
            startExamButton.heightAnchor.constraint(equalToConstant: 50),
            startExamButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startExamButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        ])
        
        startExamButton.setContentHuggingPriority(.defaultHigh, for: .vertical)
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
        
        taskViewController.dismiss(animated: true) {
            
            if reason == .completed {
                switch self.state {
                case .consent:
                    self.presentSurvey()
                    
                case .survey:
                    
                    let results = taskViewController.result.results
                    
                    if let first = results?.first as? ORKStepResult, first.identifier == "myTouch.survey.participantID" {
                        if let answer = first.results?.first as? ORKNumericQuestionResult, let id = answer.answer as? Int {
                            
                            let session = Session()
                            session.participantId = id
    
                            SessionManager.shared.currentSession = session
                            self.presentTaskColleciton()
                        }
                    }
                    
                default: break
                }
            }
        }
    }
    
}
