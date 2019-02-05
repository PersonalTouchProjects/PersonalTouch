//
//  HomeViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/1/10.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit
import ResearchKit

class HomeViewController: SessionDetailViewController {

    let sessionController = SessionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "MyTouch"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Test", style: .plain, target: self, action: #selector(handleNewTestButton(sender:)))
        
    }
    
    @objc private func handleNewTestButton(sender: UIBarButtonItem) {
        
        let task = ORKOrderedTask.touchAbilityTask(withIdentifier: "touch", intendedUseDescription: nil, taskOptions: [.tap], options: [])
        let taskViewController = ORKTaskViewController(task: task, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
        
//        let taskViewController = ORKTaskViewController(task: Survey().task(), taskRun: nil)
//        taskViewController.delegate = self
//        present(taskViewController, animated: true, completion: nil)
        
//        let alertController = UIAlertController(title: "New Test", message: "To infinity, and beyond!", preferredStyle: .alert)
//        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//
//        alertController.addAction(action)
//        alertController.preferredAction = action
//
//        present(alertController, animated: true, completion: nil)
    }
}

extension HomeViewController: ORKTaskViewControllerDelegate {
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
        for result in taskViewController.result.results ?? [] {
            if result.identifier == "touchAbilityTap" {
                
                let tapResult = (result as! ORKStepResult).results?.first as! ORKTouchAbilityTapResult
                let tapTask = TapTask(result: tapResult)
                
                let encoder = JSONEncoder()
                encoder.nonConformingFloatEncodingStrategy = .convertToString(positiveInfinity: "+inf", negativeInfinity: "-inf", nan: "nan")
                encoder.dateEncodingStrategy = .iso8601
                encoder.outputFormatting = .prettyPrinted
                
                if let json = try? encoder.encode(tapTask) {
                    print(String(data: json, encoding: .utf8)!)
                }
            }
        }
        
        
        taskViewController.dismiss(animated: true, completion: nil)
    }

}
