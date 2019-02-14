//
//  SessionController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/2/2.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit
import ResearchKit

extension Notification.Name {
    static let sessionControllerDidChangeState = Notification.Name("sessionControllerDidChangeState")
}

class SessionController {

    static let shared = SessionController()
    
    enum State {
        case initial
        case success(sessions: [Session])
        case error(error: Error)
        
        var sessions: [Session]? {
            if case .success(let sessions) = self {
                return sessions
            }
            return nil
        }
        
        var error: Error? {
            if case .error(let error) = self {
                return error
            }
            return nil
        }
    }
    
    private(set) var state: State = .initial
    
    var document = ORKConsentDocument()
    private let client = APIClient()
    private var isFetching = false
    private var fetchingLock = NSLock()
    
    // MARK: - API
    
    func fetchSessions() {
       
        fetchingLock.lock()
        
        guard !isFetching else {
            fetchingLock.unlock()
            return
        }
        
        isFetching = true
        fetchingLock.unlock()
        
        client.fetchSessionResults { (sessions, error) in
            
            if let error = error {
                self.state = .error(error: error)
            } else if let sessions = sessions {
                self.state = .success(sessions: sessions)
            } else {
                self.state = .success(sessions: [])
            }
            
            self.isFetching = false
            
            let notification = Notification(name: .sessionControllerDidChangeState, object: self, userInfo: nil)
            NotificationQueue.default.enqueue(notification, postingStyle: .asap)
        }
    }
    
    
    // MARK: - Predefined Tasks
    
    func consentTask() -> ORKOrderedTask {
        
        document = ORKConsentDocument()
        document.title = "Test Consent"
        
        let sectionTypes: [ORKConsentSectionType] = [
            .overview,
//            .dataGathering,
//            .privacy,
//            .dataUse,
//            .timeCommitment,
//            .studySurvey,
//            .studyTasks,
//            .withdrawing
        ]
        
        let consentSections: [ORKConsentSection] = sectionTypes.map { contentSectionType in
            let consentSection = ORKConsentSection(type: contentSectionType)
            consentSection.summary = "Complete the study"
            consentSection.content = "This survey will ask you three questions and you will also measure your tapping speed by performing a small activity."
            return consentSection
        }
        
        document.sections = consentSections
        document.addSignature(ORKConsentSignature(forPersonWithTitle: "User", dateFormatString: nil, identifier: "signature"))
        
        var steps = [ORKStep]()
        
        let visualConsentStep = ORKVisualConsentStep(identifier: "visualConsent", document: document)
        steps.append(visualConsentStep)
        
        let signature = document.signatures?.first
        let reviewStep = ORKConsentReviewStep(identifier: "review", signature: signature, in: document)
        reviewStep.text = "Review the consent"
        reviewStep.reasonForConsent = "Consent to join the Research Study."
        steps.append(reviewStep)
        
        let completionStep = ORKCompletionStep(identifier: "completion")
        completionStep.title = "Welcome"
        completionStep.text = "Thank you."
        steps.append(completionStep)
        
        return ORKOrderedTask(identifier: "consentTask", steps: steps)
    }
    
    func surveyTask() -> ORKOrderedTask {
        
        var steps = [ORKStep]()
        
        let instructionStep = ORKInstructionStep(identifier: "intro")
        instructionStep.title = "Test Survey"
        instructionStep.text = "Answer three questions to complete the survey."
        steps += [instructionStep]
        
        let ageQuestion = "How old are you?"
        let ageAnswer = ORKNumericAnswerFormat.integerAnswerFormat(withUnit: "years")
        ageAnswer.minimum = 18
        ageAnswer.maximum = 85
        let ageQuestionStep = ORKQuestionStep(identifier: "age", title: ageQuestion, question: nil, answer: ageAnswer)
        steps += [ageQuestionStep]
        
        let nameAnswerFormat = ORKTextAnswerFormat(maximumLength: 20)
        nameAnswerFormat.multipleLines = false
        let nameQuestionStepTitle = "What is your name?"
        let nameQuestionStep = ORKQuestionStep(identifier: "name", title: nameQuestionStepTitle, question: nil, answer: nameAnswerFormat)
        steps += [nameQuestionStep]
        
        let completionStep = ORKCompletionStep(identifier: "summary")
        completionStep.title = "Thank You!!"
        completionStep.text = "You have completed the survey"
        steps += [completionStep]
        
        
        // skip name question if age is 20
        
        let predicate = ORKResultPredicate.predicateForNumericQuestionResult(with: ORKResultSelector(resultIdentifier: ageQuestionStep.identifier), expectedAnswer: 20)
        let rule = ORKPredicateStepNavigationRule(resultPredicatesAndDestinationStepIdentifiers: [(predicate, completionStep.identifier)])
        
        let task = ORKNavigableOrderedTask(identifier: "survey", steps: steps)
        task.setNavigationRule(rule, forTriggerStepIdentifier: ageQuestionStep.identifier)
        
        return task
    }
    
    func activityTask() -> ORKOrderedTask {
        return ORKOrderedTask.touchAbilityTask(withIdentifier: "touch", intendedUseDescription: nil, taskOptions: [.tap], options: [])
    }
}





internal func defaultDirectoryPath() -> URL {
    var url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    url = url.appendingPathComponent("MyTouch/v1")
    
    do {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    } catch {
        print("Cannot create MyTouch directory under Application Support. error: \(error.localizedDescription)")
    }
    return url
}

internal func path(with date: Date) -> URL {
    
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(identifier: "UTC")
    formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
    
    let formatted = formatter.string(from: date)
    
    return defaultDirectoryPath().appendingPathComponent("\(formatted).json")
}
