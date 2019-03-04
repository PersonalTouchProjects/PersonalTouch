//
//  SessionListViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/1/16.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit

extension SessionListViewController {
    
    enum State {
        case loading
        case empty
        case sessions(sessions: [Session])
        case error(error: Error)
    }
}

class SessionListViewController: UIViewController {
    
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    let stateView = StateView()
    let tableView = UITableView(frame: .zero, style: .plain)
    let refreshControl = UIRefreshControl()
    let backgroundView = UIView()
    let topShadowView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "MyTouch"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "New Test",
            style: .plain,
            target: self,
            action: #selector(handleNewTestButton(sender:))
        )
        
        view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        backgroundView.backgroundColor = UIColor(hex: 0x00b894)
        topShadowView.backgroundColor = UIColor(white: 0.0, alpha: 0.15)
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.register(SessionListCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 88
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.contentInset.bottom = 20
        
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(handleRefreshControl(sender:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        stateView.button.addTarget(self, action: #selector(handleStateViewButton(sender:)), for: .touchUpInside)
        
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(backgroundView)
        view.addSubview(tableView)
        view.addSubview(stateView)        
        view.addSubview(topShadowView)
        view.addSubview(activityIndicator)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        stateView.translatesAutoresizingMaskIntoConstraints = false
        topShadowView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stateView.topAnchor.constraint(equalTo: view.topAnchor),
            stateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            stateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            stateView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15),
            
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2/5),
            
            topShadowView.topAnchor.constraint(equalTo: view.topAnchor),
            topShadowView.leftAnchor.constraint(equalTo: view.leftAnchor),
            topShadowView.rightAnchor.constraint(equalTo: view.rightAnchor),
            topShadowView.heightAnchor.constraint(equalToConstant: 1),
            
            activityIndicator.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)
        ])
        
        stateView.isHidden = true
        tableView.isHidden = true
        topShadowView.alpha = 0.0
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleSessionsNotification(notification:)),
            name: .sessionControllerDidChangeState,
            object: nil
        )
        
        if homeTabBarController.isLoaded {
            activityIndicator.stopAnimating()
            layoutContents()
        } else {
            activityIndicator.startAnimating()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func layoutContents() {
        
        if homeTabBarController.error == nil && homeTabBarController.sessions.isEmpty {
            
            tableView.isHidden = true
            stateView.isHidden = false
            
            // Display onboarding view
            
            stateView.titleLabel.text = "Welcom to MyTouch"
            stateView.textLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
            stateView.button.setTitle("Start", for: .normal)
            
        } else {
            
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

    @objc private func handleSessionsNotification(notification: Notification) {
        DispatchQueue.main.async {
            self.tableView.contentOffset.y = 0
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            self.activityIndicator.stopAnimating()
            self.layoutContents()
        }
    }
    
    @objc private func handleRefreshControl(sender: UIRefreshControl) {
        homeTabBarController.reloadSessions()
    }

    @objc private func handleNewTestButton(sender: UIBarButtonItem) {
        homeTabBarController.presentSurveyAndActivity()
    }
    
    @objc private func handleStateViewButton(sender: UIButton) {
        homeTabBarController.presentSurveyAndActivity()
    }
    
    private var homeTabBarController: HomeTabBarController {
        return tabBarController as! HomeTabBarController
    }
}

extension SessionListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeTabBarController.sessions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let result = homeTabBarController.sessions[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SessionListCell
        cell.titleLabel.text          = result.deviceInfo.name                                         // "Tommy's iPhone"
        cell.dateLabel.text           = result.end.readableString                                      // "2019/01/01"
        cell.stateLabel.text          = result.state.rawValue                                          // "Completed"
        cell.osLabel.text             = "\(result.deviceInfo.platform) \(result.deviceInfo.osVersion)" // "iOS 12.1.2"
        cell.versionLabel.text        = "MyTouch \(result.deviceInfo.appVersion)"                      // "MyTouch 2.0.0"
        cell.iconView.backgroundColor = result.state.color
        return cell
    }
}

extension SessionListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailViewController = SessionDetailViewController()
        detailViewController.session = homeTabBarController.sessions[indexPath.row]
        detailViewController.hidesBottomBarWhenPushed = true
        show(detailViewController, sender: self)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.15, delay: 0.0, options: [.beginFromCurrentState], animations: {
            self.topShadowView.alpha = scrollView.contentOffset.y > 0 ? 1.0 : 0.0
        }, completion: nil)
    }
}
