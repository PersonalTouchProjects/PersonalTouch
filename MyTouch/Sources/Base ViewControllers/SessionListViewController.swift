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
    private var cache = NSCache<NSString, Session>()
    
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
            sessions.sort { $0.absoluteString < $1.absoluteString }
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
            var session = cache.object(forKey: url.absoluteString as NSString)
            
            if session == nil {
                let data = try Data(contentsOf: url)
                
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                jsonDecoder.nonConformingFloatDecodingStrategy = .convertFromString(
                    positiveInfinity: "infinity",
                    negativeInfinity: "-infinity",
                    nan: "nan"
                )
                
                let decoded = try jsonDecoder.decode(Session.self, from: data)
                
                cache.setObject(decoded, forKey: url.absoluteString as NSString)
                
                session = decoded
            }
            
            let viewController = SessionContentsViewController()
            viewController.session = session
            viewController.hidesBottomBarWhenPushed = true
            
            show(viewController, sender: nil)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "刪除") { (action, indexPath) in
            
            let alertController = UIAlertController(title: "刪除", message: "確定要刪除這筆紀錄嗎？", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "刪除", style: .destructive) { (action) in
                let url = self.sessions[indexPath.row]
                do {
                    try FileManager.default.removeItem(at: url)
                    self.sessions.remove(at: indexPath.row)
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    self.tableView.endUpdates()
                } catch {
                    print(error.localizedDescription)
                }
            }
            let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            alertController.addAction(confirm)
            alertController.addAction(cancel)
            alertController.preferredAction = cancel
            
            self.present(alertController, animated: true, completion: nil)
        }
        return [deleteAction]
    }
}
