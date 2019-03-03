//
//  AppController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/3/1.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit
import ResearchKit

class AppController: NSObject {
    
    static let shared = AppController()
    
    var sessionController = SessionController()
    var researchController = ResearchController()
    
    private var currentViewController: UIViewController?
    
    var isConsented: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaults.Key.consented)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Key.consented)
        }
    }
    
    override init() {
        super.init()
        researchController.delegate = self
    }
    
    func presentConsentIfNeeded(in viewController: UIViewController) {
        if !isConsented {
            currentViewController = viewController
            researchController.showConsent(in: viewController)
        }
    }
    
    func presentSurvey(in viewController: UIViewController) {
        currentViewController = viewController
        researchController.showSurvey(in: viewController)
    }
    
    func presentActivity(with session: Session, in viewController: UIViewController) {
        currentViewController = viewController
        researchController.showActivity(with: session, in: viewController)
    }
    
    
    // MARk: - Error Handling
    
    private func presentErrorAlert(with error: Error, in viewController: UIViewController) {
        
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(action)
        viewController.present(alertController, animated: true, completion: nil)
    }
}

extension AppController: ResearchControllerDelegate {
    
    func researchControllerDidFinishConsent(with reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
        switch reason {
        case .completed:
            isConsented = true
        
        case .failed:
            if let error = error, let vc = currentViewController {
                presentErrorAlert(with: error, in: vc)
            }
            
        default:
            break
        }
    }
    
    func researchControllerDidFinishSurvey(with reason: ORKTaskViewControllerFinishReason, session: Session?, error: Error?) {
        
        switch reason {
        case .completed:
            if let vc = currentViewController {
                researchController.showActivity(with: session!, in: vc)
            }
            
        case .failed:
            if let error = error, let vc = currentViewController {
                presentErrorAlert(with: error, in: vc)
            }
            
        default:
            break
        }
    }
    
    func researchControllerDidFinishActivity(with reason: ORKTaskViewControllerFinishReason, session: Session?, error: Error?) {
        
        switch reason {
        case .completed:
            if let session = session {
                sessionController.addTemporarySession(session)
            }
            
            sessionController.fetchSessions()
            
        case .failed:
            if let error = error, let vc = currentViewController {
                presentErrorAlert(with: error, in: vc)
            }
            
        default:
            break
        }
    }
    
    
}
