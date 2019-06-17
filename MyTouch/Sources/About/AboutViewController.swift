//
//  AboutViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/1/17.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit
import LicensesViewController

class AboutViewController: UIViewController {

    let tableView = UITableView(frame: .zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = NSLocalizedString("NAVIGATION_TITLE_ABOUT", comment: "")
        
        view.backgroundColor = UIColor.white
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.register(DetailTextCell.self, forCellReuseIdentifier: "cell")
        tableView.register(ButtonCell.self, forCellReuseIdentifier: "button")
        tableView.estimatedRowHeight = 44
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(white: 242/255, alpha: 1.0)
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

extension AboutViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2
        case 1: return 2
        case 2: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = NSLocalizedString("ABOUT_VERSION_TITLE", comment: "")
            cell.detailTextLabel?.text = UIApplication.shared.appVersion
            
        case (0, 1):
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = NSLocalizedString("ABOUT_LICENSE_TITLE", comment: "")
            cell.accessoryType = .disclosureIndicator
            
        case (1, 0):
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = NSLocalizedString("ABOUT_MYTOUCH_TITLE", comment: "")
            cell.accessoryType = .disclosureIndicator
            
        case (1, 1):
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = NSLocalizedString("ABOUT_CONTACT_TITLE", comment: "")
            cell.accessoryType = .disclosureIndicator
            
            
        default: fatalError()
        }
        
        return cell
    }
}

extension AboutViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return NSLocalizedString("ABOUT_VERSION_INFO_SECTION_TITLE", comment: "")
        case 1: return NSLocalizedString("ABOUT_ABOUT_APP_SECTION_TITLE", comment: "")
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        switch (indexPath.section, indexPath.row) {
        
        // License
        case (0, 1):
            let licensesController = LicensesViewController()
            licensesController.loadPlist(Bundle.main, resourceName: "Credits")
            show(licensesController, sender: self)
            
        // About MyTouch
        case (1, 0):
            let url = URL(string: "https://doi.org/10.1145/3290605.3300913")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        // Contact
        case (1, 1):
            let url = URL(string: "https://mikechen.com")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            return false
            
        default:
            return true
        }
    }
}

private extension AboutViewController {
    
    class DetailTextCell: UITableViewCell {
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .value1, reuseIdentifier: reuseIdentifier)
            selectionStyle = .none
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func setHighlighted(_ highlighted: Bool, animated: Bool) {
            super.setHighlighted(highlighted, animated: animated)
            
            backgroundColor = highlighted ? UIColor(white: 230/255, alpha: 1.0) : UIColor.white
        }
    }
    
    class ButtonCell: UITableViewCell {
        
        let buttonLabel = UILabel()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            selectionStyle = .none
            
            buttonLabel.font = UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: .medium)
            buttonLabel.textColor = UIColor(red:0.92, green:0.01, blue:0.00, alpha:1.00)
            buttonLabel.textAlignment = .center
            
            contentView.addSubview(buttonLabel)
            
            buttonLabel.frame = contentView.bounds
            buttonLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func setHighlighted(_ highlighted: Bool, animated: Bool) {
            super.setHighlighted(highlighted, animated: animated)
            
            backgroundColor = highlighted ? UIColor(white: 230/255, alpha: 1.0) : UIColor.white
        }
    }
}
