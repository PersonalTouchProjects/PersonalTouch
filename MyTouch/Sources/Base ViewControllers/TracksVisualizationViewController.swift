//
//  TracksVisualizationViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/24.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TracksVisualizationViewController: UIViewController {

    let tracksView = TracksVisualizationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "軌跡"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(handlePlay(_:)))
        
        tracksView.backgroundColor = .white
        tracksView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tracksView)
        
        NSLayoutConstraint.activate([
            tracksView.topAnchor.constraint(equalTo: view.topAnchor),
            tracksView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tracksView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tracksView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tracksView.startAnimating()
    }
    
    @objc private func handlePlay(_ sender: UIBarButtonItem) {
        tracksView.startAnimating()
    }
}
