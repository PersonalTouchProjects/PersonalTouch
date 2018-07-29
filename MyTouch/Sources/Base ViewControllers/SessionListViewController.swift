//
//  SessionListViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/29.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class SessionListViewController: UIViewController {

    let tableView = UITableView(frame: .zero, style: .plain)
    
    private var sessions = [URL]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "測驗結果"
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        do {
            sessions = try FileManager.default.contentsOfDirectory(at: defaultDirectoryPath(), includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            tableView.reloadData()
            
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension SessionListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = sessions[indexPath.row].lastPathComponent
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let url = sessions[indexPath.row]
        
        do {
            let data = try Data(contentsOf: url)
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            jsonDecoder.nonConformingFloatDecodingStrategy = .convertFromString(
                positiveInfinity: "infinity",
                negativeInfinity: "-infinity",
                nan: "nan"
            )
            
            let session = try jsonDecoder.decode(Session.self, from: data)
            
            let viewController = SessionContentsViewController()
            viewController.session = session
            
            show(viewController, sender: nil)
            
        } catch {
            print(error.localizedDescription)
        }
    }
}
