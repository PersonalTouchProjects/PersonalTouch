//
//  SessionListViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/1/16.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit

class SessionListViewController: UIViewController {
    
    var appController: AppController?
    
    var sessionResults: [Session] = []
    
    let onboardingView = OnboardingView()
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
        
        view.addSubview(backgroundView)
        view.addSubview(tableView)
        view.addSubview(onboardingView)        
        view.addSubview(topShadowView)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        onboardingView.translatesAutoresizingMaskIntoConstraints = false
        topShadowView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            onboardingView.topAnchor.constraint(equalTo: view.topAnchor),
            onboardingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            onboardingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            onboardingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15),
            
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3),
            
            topShadowView.topAnchor.constraint(equalTo: view.topAnchor),
            topShadowView.leftAnchor.constraint(equalTo: view.leftAnchor),
            topShadowView.rightAnchor.constraint(equalTo: view.rightAnchor),
            topShadowView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        tableView.isHidden = true
        topShadowView.alpha = 0.0
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleSessionsNotification(notification:)),
            name: .sessionControllerDidChangeState,
            object: nil
        )
        
        sessionResults = AppController.shared.sessionController.state.sessions ?? []
        layout()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func layout() {
        
        switch AppController.shared.sessionController.state {
            
        case .initial:
            self.tableView.isHidden = true
            self.onboardingView.isHidden = false
            self.onboardingView.titleLabel.text = "載入中"
            self.onboardingView.textLabel.text = nil
            
        case .success(let sessions):
            self.sessionResults = sessions
            if self.refreshControl.isRefreshing {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    self.refreshControl.endRefreshing()
                }
            }
            self.tableView.reloadData()
            self.tableView.isHidden = false
            self.onboardingView.isHidden = true
            
        case .loading:
            break
            
        default:
            self.tableView.isHidden = true
            self.onboardingView.isHidden = false
        }
    }
    
    @objc private func handleSessionsNotification(notification: Notification) {
        layout()
    }
    
    @objc private func handleRefreshControl(sender: UIRefreshControl) {
        
        AppController.shared.sessionController.fetchSessions()
    }

    @objc private func handleNewTestButton(sender: UIBarButtonItem) {
        
        AppController.shared.presentSurvey(in: self)
    }
}

extension SessionListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessionResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SessionListCell
        
        let result = sessionResults[indexPath.row]
        
        cell.titleLabel.text = result.deviceInfo.name // "Tommy's iPhone"
        cell.dateLabel.text = APIClient.dateFormatter.string(from: result.end) // "2019/01/01"
        cell.stateLabel.text = result.state.rawValue // "Completed"
        cell.osLabel.text = "\(result.deviceInfo.platform) \(result.deviceInfo.osVersion)" // "iOS 12.1.2"
        cell.versionLabel.text = "MyTouch \(result.deviceInfo.appVersion)" // "MyTouch 2.0.0"
        cell.iconView.backgroundColor = result.state.color
        
        return cell
    }
}

extension SessionListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailViewController = SessionDetailViewController()
        detailViewController.session = sessionResults[indexPath.row]
        detailViewController.hidesBottomBarWhenPushed = true
        show(detailViewController, sender: self)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.15, delay: 0.0, options: [.beginFromCurrentState], animations: {
            self.topShadowView.alpha = scrollView.contentOffset.y > 0 ? 1.0 : 0.0
        }, completion: nil)
    }
}
