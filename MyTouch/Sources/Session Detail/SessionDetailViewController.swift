//
//  SessionDetailViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/1/16.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit

class SessionDetailViewController: UIViewController {
    
    var session: Session? {
        didSet { tableView.reloadData() }
    }
    
    let topShadowView = UIView()
    let backgroundView = UIView()
    let briefLabel = UILabel()
    let tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(handleShareButton(sender:)))
        
        backgroundView.backgroundColor = UIColor(hex: 0x00b894)
        topShadowView.backgroundColor = UIColor(white: 0.0, alpha: 0.15)
        
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byWordWrapping
        style.lineSpacing = 8.0
        style.alignment = .center
        
        let attrs = [
            NSAttributedString.Key.paragraphStyle: style,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular)
        ]
        
        briefLabel.attributedText = NSAttributedString(string: "2019/1/1 10:05pm\nTest on Tommy’s iPhone", attributes: attrs)
        briefLabel.numberOfLines = 0
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.register(AccomodationCell.self, forCellReuseIdentifier: "accomodation")
        tableView.register(SessionInfoCell.self, forCellReuseIdentifier: "info")
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundView = nil
        tableView.backgroundColor = .clear
        tableView.contentInset.top = 80
        tableView.contentInset.bottom = 20

        view.addSubview(backgroundView)
        view.addSubview(briefLabel)
        view.addSubview(tableView)
        view.addSubview(topShadowView)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        briefLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        topShadowView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            briefLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 1.0),
            briefLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            briefLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            briefLabel.heightAnchor.constraint(equalToConstant: 60),
            
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

    @objc private func handleShareButton(sender: UIBarButtonItem) {
        
        let activity = UIActivityViewController(activityItems: ["MyTouch Sharing"], applicationActivities: [])
        present(activity, animated: true, completion: nil)
    }
    
    @objc private func handleAccomodationButton(sender: UIButton) {
        
        let alertController = UIAlertController(title: "Settings", message: "To infinity, and beyond!", preferredStyle: .alert)
        let action = UIAlertAction(title: "GO", style: .default) { action in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancel)
        alertController.addAction(action)
        alertController.preferredAction = action
        
        present(alertController, animated: true, completion: nil)
    }
}

extension SessionDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "accomodation", for: indexPath) as! AccomodationCell
            
            if let session = session {
                if let value = session.holdDuration, value != 0 { cell.holdDurationText = "\(value)" }
                if let value = session.ignoreRepeat, value != 0 { cell.ignoreRepeatText = "\(value)" }
                if let value = session.touchAssistant?.value, value != 0 { cell.accomodationText = "\(value)" }
            } else {
                cell.holdDurationText = "0.5"
                cell.ignoreRepeatText = "0.2"
                cell.accomodationText = "0.6"
            }
            cell.button.addTarget(self, action: #selector(handleAccomodationButton(sender:)), for: .touchUpInside)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "info", for: indexPath) as! SessionInfoCell
            cell.titleLabel.text = "Device Info"
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "info", for: indexPath) as! SessionInfoCell
            cell.titleLabel.text = "Subject Info"
            return cell
        default:
            fatalError()
        }
    }
}

extension SessionDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if abs(scrollView.contentOffset.y) < scrollView.contentInset.top {
            let scale = max(abs(scrollView.contentOffset.y) / scrollView.contentInset.top, 0)
            briefLabel.transform = CGAffineTransform(translationX: 0, y: -40 * (1 - scale)).scaledBy(x: 0.5 + scale/2, y: 0.5 + scale/2)
            briefLabel.alpha = scale
        } else if scrollView.contentOffset.y > 0 {
            briefLabel.alpha = 0.0
        } else {
            briefLabel.transform = .identity
            briefLabel.alpha = 1.0
        }
        
        UIView.animate(withDuration: 0.15, delay: 0.0, options: [.beginFromCurrentState], animations: {
            self.topShadowView.alpha = scrollView.contentOffset.y > 0 ? 1.0 : 0.0
        }, completion: nil)
    }
}
