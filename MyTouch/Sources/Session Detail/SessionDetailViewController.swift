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
            navigationItem.rightBarButtonItem = session?.state == .completed ? shareButton : nil
            tableView.reloadData()
        }
    }
    
    let topShadowView = UIView()
    let backgroundView = UIView()
    let briefLabel = UILabel()
    let tableView = UITableView(frame: .zero, style: .plain)
    
    private lazy var shareButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "icon_share"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(handleShareButton(sender:)))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
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
        
        let shareText = "此中軍則己料友看始紙成我。活算上德，沒知反最年上護獲有了。設持什河一說重音輕的情，能現英會？火再地過明玩一登的，人五下……年畫成，神自部：增強燈舉力開家善數手半告依效化任南場坡家坐朋蘭經表遠族教動……實盡裡筆切得連國整商表父。"
        
        let activity = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
        present(activity, animated: true, completion: nil)
    }
    
    @objc private func handleAccomodationButton(sender: UIButton) {
        
        guard let session = session else {
            return
        }
        
        switch session.state {
        case .local:
            // TODO: Upload
            print("To be uploaded")
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
            cell.titleLabel.text = "Device Info"
            
            if let deviceInfo = session?.deviceInfo {
                cell.items = [
                    SessionInfoCell.Item(title: "Device name", text: deviceInfo.name),
                    SessionInfoCell.Item(title: "Model name", text: deviceInfo.model),
                    SessionInfoCell.Item(title: "Manufacturer", text: deviceInfo.manufacturer),
                    SessionInfoCell.Item(title: "OS version", text: "\(deviceInfo.platform) \(deviceInfo.osVersion)"),
                    SessionInfoCell.Item(title: "MyTouch version", text: deviceInfo.appVersion)
                ]
            }
            cell.layoutItemViews()
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "info", for: indexPath) as! SessionInfoCell
            cell.titleLabel.text = "Subject Info"
            
            if let subject = session?.subject {
                cell.items = [
                    SessionInfoCell.Item(title: "Name", text: subject.name),
                    SessionInfoCell.Item(title: "Birth year", text: "\(subject.birthYear)"),
                    SessionInfoCell.Item(title: "Gender", text: subject.gender.rawValue),
                    SessionInfoCell.Item(title: "DominantHand", text: subject.dominantHand.rawValue),
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
