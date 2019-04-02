//
//  HomeViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/1/10.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit

class HomeViewController: SessionDetailViewController {
    
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    let stateView = StateView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "MyTouch"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "New Test",
            style: .plain,
            target: self,
            action: #selector(handleNewTestButton(sender:))
        )
        
        stateView.button.addTarget(self, action: #selector(handleStateViewButton(sender:)), for: .touchUpInside)
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(stateView)
        view.addSubview(activityIndicator)
        
        stateView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stateView.topAnchor.constraint(equalTo: view.topAnchor),
            stateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            stateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            stateView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15),
            
            activityIndicator.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)
        ])
        
        stateView.isHidden = true
        tableView.isHidden = true
        briefLabel.isHidden = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleSessionsNotification(notification:)),
            name: .sessionsDidLoad,
            object: nil
        )
        
        if homeTabBarController.isSessionsLoaded {
            activityIndicator.stopAnimating()
            layoutContents()
        } else {
            activityIndicator.startAnimating()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleSessionsNotification(notification: Notification) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.layoutContents()
        }
    }
    
    @objc private func handleNewTestButton(sender: UIBarButtonItem) {
        homeTabBarController.presentSurveyAndActivity()
    }
    
    @objc private func handleStateViewButton(sender: UIButton) {
        homeTabBarController.presentSurveyAndActivity()
    }
    
    private func layoutContents() {
        
        if homeTabBarController.error == nil && homeTabBarController.sessions.first == nil {
            
            briefLabel.isHidden = true
            tableView.isHidden = true
            stateView.isHidden = false
            
            // Display onboarding view
            
            stateView.titleLabel.text = "Welcom to MyTouch"
            stateView.textLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
            stateView.button.setTitle("Start", for: .normal)
            
        } else {
            
            session = homeTabBarController.sessions.first
            
            briefLabel.isHidden = false
            tableView.isHidden = false
            stateView.isHidden = true
            
            if let error = homeTabBarController.error {
                let alertController = UIAlertController(title: "錯誤", message: error.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alertController.addAction(action)
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    private var homeTabBarController: HomeTabBarController {
        return tabBarController as! HomeTabBarController
    }
}

