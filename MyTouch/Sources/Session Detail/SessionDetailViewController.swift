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
        didSet {
            if let session = session {
                let style = NSMutableParagraphStyle()
                style.lineBreakMode = .byWordWrapping
                style.lineSpacing = 8.0
                style.alignment = .center
                
                let attrs = [
                    NSAttributedString.Key.paragraphStyle: style,
                    NSAttributedString.Key.foregroundColor: UIColor.white,
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular)
                ]
                
                let formatter = DateFormatter()
                formatter.calendar = Calendar.current
                formatter.timeZone = TimeZone.current
                formatter.dateStyle = .long
                
                let dateString = formatter.string(from: session.start)
                
                briefLabel.attributedText = NSAttributedString(string: "\(dateString)\n Tommy’s iPhone", attributes: attrs)
            }
            
            tableView.reloadData()
        }
    }
    
    let topShadowView = UIView()
    let backgroundView = UIView()
    let briefLabel = UILabel()
    let tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        backgroundView.backgroundColor = UIColor(hex: 0x00b894)
        topShadowView.backgroundColor = UIColor(white: 0.0, alpha: 0.15)
        
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
    
    @objc private func handleAccomodationButton(sender: UIButton) {
        
        guard let session = session else {
            return
        }
        
        switch session.state {
        case .local:
            
            let homeTabBarController = tabBarController as? HomeTabBarController
            homeTabBarController?.uploadSession(session) { [weak self] (session, error) in
                if let session = session {
                    self?.session = session
                }
            }
            
        case .completed:
            presentGoToSettings()
            
        default:
            break
        }
    }
    
    private func presentGoToSettings() {
        
        let viewController = SettingsStepByStepViewController()
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        present(viewController, animated: true, completion: nil)
    }
}

extension SessionDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return session != nil ? 3 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "accomodation", for: indexPath) as! AccomodationCell
            
            if let session = session {
                cell.session = session
            }
            cell.button.addTarget(self, action: #selector(handleAccomodationButton(sender:)), for: .touchUpInside)
            cell.layoutItemViews()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "info", for: indexPath) as! SessionInfoCell
            cell.titleLabel.text = NSLocalizedString("DEVICE_INFO_TITLE", comment: "")
            
            if let deviceInfo = session?.deviceInfo {
                cell.items = [
                    SessionInfoCell.Item(title: NSLocalizedString("DEVICE_INFO_DEVICE_NAME", comment: ""), text: deviceInfo.name),
                    SessionInfoCell.Item(title: NSLocalizedString("DEVICE_INFO_MODEL_NAME", comment: ""), text: deviceInfo.model),
                    SessionInfoCell.Item(title: NSLocalizedString("DEVICE_INFO_MANUFACTURER", comment: ""), text: deviceInfo.manufacturer),
                    SessionInfoCell.Item(title: NSLocalizedString("DEVICE_INFO_OS_VERSION", comment: ""), text: "\(deviceInfo.platform) \(deviceInfo.osVersion)"),
                    SessionInfoCell.Item(title: NSLocalizedString("DEVICE_INFO_APP_VERSION", comment: ""), text: deviceInfo.appVersion)
                ]
            }
            cell.layoutItemViews()
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "info", for: indexPath) as! SessionInfoCell
            cell.titleLabel.text = NSLocalizedString("SUBJECT_INFO_TITLE", comment: "")
            
            // TODO: symptoms
            if let subject = session?.subject {
                cell.items = [
                    SessionInfoCell.Item(title: NSLocalizedString("SUBJECT_INFO_NAME", comment: ""), text: subject.name),
                    SessionInfoCell.Item(title: NSLocalizedString("SUBJECT_INFO_BIRTH_YEAR", comment: ""), text: "\(subject.birthYear)"),
                    SessionInfoCell.Item(title: NSLocalizedString("SUBJECT_INFO_GENDER", comment: ""), text: subject.gender.localizedString),
                    SessionInfoCell.Item(title: NSLocalizedString("SUBJECT_INFO_DOMINANT_HAND", comment: ""), text: subject.dominantHand.localizedString),
                    SessionInfoCell.Item(title: NSLocalizedString("SUBJECT_INFO_IMPAIRMENT", comment: ""), text: subject.impairment.localizedString),
                    SessionInfoCell.Item(title: NSLocalizedString("SUBJECT_INFO_SYMPTOMS", comment: ""), text: subject.symptomStrings.joined(separator: ", ")),
                ]
            }
            cell.layoutItemViews()
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


extension SessionDetailViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        if presented is SettingsStepByStepViewController {
            let presentation = CenterModalPresentationController(presentedViewController: presented, presenting: presenting)
            presentation.tapToDismiss = true
            return presentation
        }
        
        return nil
    }
}
