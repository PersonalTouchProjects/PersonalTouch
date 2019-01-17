//
//  SessionDetailViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/1/16.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit

class SessionDetailViewController: UIViewController {

    let tableView = UITableView(frame: .zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .reply, target: nil, action: nil)
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.register(AccomodationCell.self, forCellReuseIdentifier: "accomodation")
        tableView.register(SessionInfoCell.self, forCellReuseIdentifier: "cell")
        tableView.register(SessionBriefCell.self, forCellReuseIdentifier: "brief")
        tableView.register(SessionDetailHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "footer")
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.estimatedSectionHeaderHeight = 50
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.backgroundView = nil
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}

extension SessionDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 2
        case 2: return 4
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "brief", for: indexPath) as! SessionBriefCell
            cell.briefLabel.attributedText = SessionBriefCell.attributedText(for: "2019/1/1 10:05pm\nTest on Tommy’s iPhone")
            return cell
            
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "accomodation", for: indexPath) as! AccomodationCell
            cell.titleLabel.text = "Hold Duration"
            cell.valueLabel.text = "0.5"
            cell.unitLabel.text = "Sec."
            
            if indexPath.row == 1 {
                cell.extraLabel.text = "Use initial touch location"
            }
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.selectionStyle = .none
            
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Device Name"
                cell.detailTextLabel?.text = "Tommy's iPhone"
            case 1:
                cell.textLabel?.text = "Device Model"
                cell.detailTextLabel?.text = "iPhone X"
            case 2:
                cell.textLabel?.text = "Operating System"
                cell.detailTextLabel?.text = "iOS 12.1.2"
            case 3:
                cell.textLabel?.text = "MyTouch Version"
                cell.detailTextLabel?.text = "2.0.0"
            default:
                break
            }

            return cell
        }
    }
}

extension SessionDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return nil
        }
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! SessionDetailHeaderView
        
        if section == 1 {
            header.titleLabel.text = "Accomodation Suggestions"
        } else {
            header.titleLabel.text = "Session Info"
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "footer")
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
}
