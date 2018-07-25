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

        view.addSubview(tracksView)
        
        tracksView.backgroundColor = .white
        tracksView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tracksView.topAnchor.constraint(equalTo: view.topAnchor),
            tracksView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tracksView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tracksView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        do {

            let path = Bundle.main.path(forResource: "test", ofType: "json")!
            let url = URL(fileURLWithPath: path)
            
            let data = try Data(contentsOf: url)
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            jsonDecoder.nonConformingFloatDecodingStrategy = .convertFromString(
                positiveInfinity: "infinity",
                negativeInfinity: "-infinity",
                nan: "nan"
            )
            
            let json = try jsonDecoder.decode(Session.self, from: data)
            
            if let tracks = json.rotationTask?.trials[4].rawTouchTracks {
                tracksView.tracks = tracks
            }
            
        } catch {
            print(error)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tracksView.startAnimating()
    }
}
