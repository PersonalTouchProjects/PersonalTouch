//
//  HomeViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/1/10.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit
import ResearchKit

let consentUUID = UUID()
let surveyUUID = UUID()
let activityUUID = UUID()

class HomeViewController: SessionDetailViewController {

    let appController = AppController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "MyTouch"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Test", style: .plain, target: self, action: #selector(handleNewTestButton(sender:)))
        
    }
    
    @objc private func handleNewTestButton(sender: UIBarButtonItem) {
//        sessionController.showConsentIfNeeded(in: self)
        
        appController.researchController.showSurvey(in: self)
        
//        researchController.showSurvey(in: self)
    }
}

