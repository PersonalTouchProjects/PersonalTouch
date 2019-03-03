//
//  HomeViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/1/10.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit
import ResearchKit

let consentUUID = UUID()
let surveyUUID = UUID()
let activityUUID = UUID()

class HomeViewController: SessionDetailViewController {
    
    let onboardingView = OnboardingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "MyTouch"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Test", style: .plain, target: self, action: #selector(handleNewTestButton(sender:)))
        
        view.addSubview(onboardingView)

        onboardingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            onboardingView.topAnchor.constraint(equalTo: view.topAnchor),
            onboardingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            onboardingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            onboardingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15)
        ])
        
        tableView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleSessionsNotification(notification:)), name: .sessionControllerDidChangeState, object: nil)
        
        session = AppController.shared.sessionController.state.sessions?.first
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleSessionsNotification(notification: Notification) {
        session = AppController.shared.sessionController.state.sessions?.first
        self.tableView.reloadData()
    }
    
    @objc private func handleNewTestButton(sender: UIBarButtonItem) {
        AppController.shared.presentSurvey(in: self)
    }
}

