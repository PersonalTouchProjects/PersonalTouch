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

    let sessionController = SessionController.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "MyTouch"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Test", style: .plain, target: self, action: #selector(handleNewTestButton(sender:)))
        
    }
    
    @objc private func handleNewTestButton(sender: UIBarButtonItem) {
        
        let task = ORKOrderedTask.touchAbilityTask(withIdentifier: "touch", intendedUseDescription: nil, taskOptions: [.tap], options: [])
//        let taskViewController = ORKTaskViewController(task: task, taskRun: activityUUID)
        let taskViewController = ORKTaskViewController(task: sessionController.consentTask(), taskRun: consentUUID)
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
        
        if taskViewController.taskRunUUID == consentUUID {
            
            let task = taskViewController.task as! ORKOrderedTask
            let step = task.step(withIdentifier: "visualConsent") as! ORKVisualConsentStep
            
            let documentCopy = step.consentDocument!.copy() as! ORKConsentDocument
            
            if let signatureResult = taskViewController.result.stepResult(forStepIdentifier: "review")?.firstResult as? ORKConsentSignatureResult {
                
                if let image = signatureResult.signature?.signatureImage?.pngData() {
                    let path = defaultDirectoryPath().appendingPathComponent("signature.png")
                    try? image.write(to: path, options: .atomic)
                }
                
                signatureResult.apply(to: documentCopy)
            }
            
            documentCopy.makePDF { (data, error) in
                if let data = data {
                    let path = defaultDirectoryPath().appendingPathComponent("consent.pdf")
                    do {
                        try data.write(to: path, options: Data.WritingOptions.atomic)
                    } catch {
                        print(error)
                    }
                } else if let error = error {
                    print(error)
                }
            }
        }
        
        
        var session = Session(deviceInfo: DeviceInfo(), subject: Subject())
        
        for result in taskViewController.result.results ?? [] {
            if result.identifier == "touchAbilityTap" {
                
                let tapResult = (result as! ORKStepResult).results?.first as! ORKTouchAbilityTapResult
                let tapTask = TapTask(result: tapResult)
                
                
                session.tap = tapTask
                
//                try? session.archive()
            }
        }
        
        
        taskViewController.dismiss(animated: true, completion: nil)
    }

}
