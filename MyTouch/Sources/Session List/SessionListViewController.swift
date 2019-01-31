//
//  SessionListViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/1/16.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit

class SessionListViewController: UIViewController {

    let tableView = UITableView(frame: .zero, style: .plain)
    let backgroundView = UIView()
    let topShadowView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "MyTouch"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Test", style: .plain, target: self, action: #selector(handleNewTestButton(sender:)))
        
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
        
        view.addSubview(backgroundView)
        view.addSubview(tableView)
        view.addSubview(topShadowView)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        topShadowView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3),
            
            topShadowView.topAnchor.constraint(equalTo: view.topAnchor),
            topShadowView.leftAnchor.constraint(equalTo: view.leftAnchor),
            topShadowView.rightAnchor.constraint(equalTo: view.rightAnchor),
            topShadowView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        topShadowView.alpha = 0.0
    }

    @objc private func handleNewTestButton(sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "New Test", message: "To infinity, and beyond!", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(action)
        alertController.preferredAction = action
        
        present(alertController, animated: true, completion: nil)
    }
}

extension SessionListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SessionListCell
        
        cell.titleLabel.text = "Tommy's iPhone"
        cell.dateLabel.text = "2019/01/01"
        cell.stateLabel.text = "Completed"
        cell.osLabel.text = "iOS 12.1.2"
        cell.versionLabel.text = "MyTouch 2.0.0"
        return cell
    }
}

extension SessionListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailViewController = SessionDetailViewController()
        detailViewController.hidesBottomBarWhenPushed = true
        show(detailViewController, sender: self)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.15, delay: 0.0, options: [.beginFromCurrentState], animations: {
            self.topShadowView.alpha = scrollView.contentOffset.y > 0 ? 1.0 : 0.0
        }, completion: nil)
    }
}
