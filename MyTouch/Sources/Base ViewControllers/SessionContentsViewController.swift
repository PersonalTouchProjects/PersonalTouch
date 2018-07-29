//
//  SessionContentsViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/29.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class SessionContentsViewController: UIViewController {

    let tableView = UITableView(frame: .zero, style: .grouped)
    
    var session: Session? {
        didSet {
            if session?.participantId != nil {
                title = "\(session!.participantId!)"
            } else {
                title = nil
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension SessionContentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return session != nil ? 7 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let session = session else {
            return 0
        }
        
        switch section {
        case 0: return session.tapTask?.trials.count ?? 0
        case 1: return session.swipeTask?.trials.count ?? 0
        case 2: return session.dragAndDropTask?.trials.count ?? 0
        case 3: return session.horizontalScrollTask?.trials.count ?? 0
        case 4: return session.verticalScrollTask?.trials.count ?? 0
        case 5: return session.pinchTask?.trials.count ?? 0
        case 6: return session.rotationTask?.trials.count ?? 0
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = taskName(indexPath.section) + " \(indexPath.row+1)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return taskName(section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let session = session else {
            return
        }
        
        var trial: Trial?
        switch indexPath.section {
        case 0: trial = session.tapTask?.trials[indexPath.row]
        case 1: trial = session.swipeTask?.trials[indexPath.row]
        case 2: trial = session.dragAndDropTask?.trials[indexPath.row]
        case 3: trial = session.horizontalScrollTask?.trials[indexPath.row]
        case 4: trial = session.verticalScrollTask?.trials[indexPath.row]
        case 5: trial = session.pinchTask?.trials[indexPath.row]
        case 6: trial = session.rotationTask?.trials[indexPath.row]
        default: trial = nil
        }
        
        if let trial = trial {
            let viewController = TracksVisualizationViewController()
            viewController.tracksView.tracks = trial.rawTouchTracks
            
            show(viewController, sender: nil)
        }
    }
}

private func taskName(_ index: Int) -> String {
    
    let taskName: String
    switch index {
    case 0: taskName = "點擊"
    case 1: taskName = "掃動"
    case 2: taskName = "拖放"
    case 3: taskName = "水平滾動"
    case 4: taskName = "垂直滾動"
    case 5: taskName = "縮放"
    case 6: taskName = "旋轉"
    default: taskName = "其他"
    }
    
    return taskName
}
