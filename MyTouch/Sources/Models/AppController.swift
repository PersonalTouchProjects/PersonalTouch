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
    
    var sessionController = SessionController()
    var researchController = ResearchController()
    
    private var currentViewController: UIViewController?
    
    var isConsented: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "\(Bundle.main.bundleIdentifier!).consented")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "\(Bundle.main.bundleIdentifier!).consented")
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
}

extension AppController: ResearchControllerDelegate {
    
    func researchControllerDidFinishConsent(with reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
        switch reason {
        case .completed:
            isConsented = true
        
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
            
        default:
            break
        }
    }
    
    
}
