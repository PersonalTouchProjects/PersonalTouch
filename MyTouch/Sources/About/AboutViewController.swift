//
//  AboutViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/1/17.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    let tableView = UITableView(frame: .zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "About MyTouch"
        
        view.backgroundColor = UIColor.white
        
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 2 ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Version"
            cell.detailTextLabel?.text = "2.0.0"
            
        case (0, 1):
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "License"
            cell.accessoryType = .disclosureIndicator
            
        case (1, 0):
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "About MyTouch"
            cell.accessoryType = .disclosureIndicator
            
        case (1, 1):
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Contact Us"
            cell.accessoryType = .disclosureIndicator
            
        case (2, 0):
            let button = tableView.dequeueReusableCell(withIdentifier: "button", for: indexPath) as! ButtonCell
            button.buttonLabel.text = "Clear Data"
            cell = button
            
        default: fatalError()
        }
        
        return cell
    }
}

extension AboutViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Version Info"
        case 1: return "About"
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
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
