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
    let fingerCompassView = FingerCompassView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tracksView.backgroundColor = .white
        
        fingerCompassView.currentAngle = fingerCompassView.expectedAngle

        view.addSubview(tracksView)
        view.addSubview(fingerCompassView)
        
        tracksView.translatesAutoresizingMaskIntoConstraints = false
        fingerCompassView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tracksView.topAnchor.constraint(equalTo: view.topAnchor),
            tracksView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tracksView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tracksView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            fingerCompassView.topAnchor.constraint(equalTo: view.topAnchor),
            fingerCompassView.leftAnchor.constraint(equalTo: view.leftAnchor),
            fingerCompassView.rightAnchor.constraint(equalTo: view.rightAnchor),
            fingerCompassView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
            
            if let tracks = json.swipeTask?.trials[1].rawTouchTracks {
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
