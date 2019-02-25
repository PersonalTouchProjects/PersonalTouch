//
//  SessionController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/2/2.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit
import ResearchKit

class SessionController: NSObject {

    static let shared = SessionController()
    
    private(set) var state: State = .initial
    private var currentSession: Session?
    
    var hasShownConsent: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "\(Bundle.main.bundleIdentifier!).hasShownConsent")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "\(Bundle.main.bundleIdentifier!).hasShownConsent")
        }
    }
    
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
    
    
    // MARK: - Task Presentation
    
    func showConsentIfNeeded(in viewController: UIViewController) {
        if !hasShownConsent {
            showConsent(in: viewController)
        }
    }
    
    func showConsent(in viewController: UIViewController) {
        let taskViewController = ORKTaskViewController(task: consentTask(), taskRun: TaskUUID.consentUUID)
        taskViewController.delegate = self
        viewController.present(taskViewController, animated: true, completion: nil)
    }
    
    func showSurvey(in viewController: UIViewController) {
        let taskViewController = ORKTaskViewController(task: surveyTask(), taskRun: TaskUUID.surveyUUID)
        taskViewController.delegate = self
        viewController.present(taskViewController, animated: true, completion: nil)
    }
    
    func showActivity(in viewController: UIViewController) {
        let taskViewController = ORKTaskViewController(task: activityTask(), taskRun: TaskUUID.activityUUID)
        taskViewController.delegate = self
        viewController.present(taskViewController, animated: true, completion: nil)
    }
    
    
    // MARK: - Task Handling
    
    func handleConsentDidFinish(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
        defer { taskViewController.dismiss(animated: true, completion: nil) }
        
        guard reason == .completed else { return }
        
        hasShownConsent = true
        
        let step = (taskViewController.task as! ORKOrderedTask).step(withIdentifier: "visualConsent") as! ORKVisualConsentStep
        let copied = step.consentDocument!.copy() as! ORKConsentDocument
        
        if let signatureResult = taskViewController.result.stepResult(forStepIdentifier: "review")?.firstResult as? ORKConsentSignatureResult {
            signatureResult.apply(to: copied)
        }
        
        copied.makePDF { (data, error) in
            if let data = data {
                let path = defaultDocumentDirectoryPath().appendingPathComponent("consent.pdf")
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
    
    func handleSurveyDidFinish(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
        switch reason {
        case .completed:
            
            // Generate subject object
            var subject = Subject()
            
            let birthResult = taskViewController.result.stepResult(forStepIdentifier: "birth")?.result(forIdentifier: "birth") as! ORKNumericQuestionResult
            subject.birthYear = birthResult.numericAnswer!.intValue
            
            let  nameResult = taskViewController.result.stepResult(forStepIdentifier: "name")?.result(forIdentifier: "name") as! ORKTextQuestionResult
            subject.name = nameResult.textAnswer!
            
            let genderResult = taskViewController.result.stepResult(forStepIdentifier: "gender")?.result(forIdentifier: "gender") as! ORKChoiceQuestionResult
            if let answer = genderResult.choiceAnswers?.first as? String {
                subject.gender = Subject.Gender(rawValue: answer) ?? .other
            }
            
            let handResult = taskViewController.result.stepResult(forStepIdentifier: "hand")?.result(forIdentifier: "hand") as! ORKChoiceQuestionResult
            if let answer = handResult.choiceAnswers?.first as? String {
                subject.dominantHand = Subject.DominantHand(rawValue: answer) ?? .none
            }
            
            // End of generate subject
            
            
            // Set current session
            currentSession = Session(deviceInfo: DeviceInfo(), subject: subject)
            
            
            // Dismiss survey and show activity
            let presentingViewController = taskViewController.presentingViewController
            
            assert(presentingViewController != nil, "presenting view controller must not be nil!")
            
            taskViewController.dismiss(animated: true) {
                
                // Update current session start date
                self.currentSession?.start = Date()
                
                // Present activity view controller in current presenting view controller
                self.showActivity(in: presentingViewController!)
            }
            
        default:
            taskViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    func handleActivityDidFinish(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
        defer { taskViewController.dismiss(animated: true, completion: nil) }
        
        guard reason == .completed else { return }
        
        guard var session = currentSession else {
            fatalError("current session missing!")
        }
        
        session.end = Date()
        
        if let tapResult = taskViewController.result.stepResult(forStepIdentifier: "touchAbilityTap")?.results?.first as? ORKTouchAbilityTapResult {
            session.tap = TapTask(result: tapResult)
        }
        
        // End of Generate session object.
        
        // Save session as local cache
        
        do {
            let data = try APIClient.encoder.encode(session)
            let path = defaultDocumentDirectoryPath().appendingPathComponent("12345").appendingPathExtension("json")
            
            try data.write(to: path, options: .atomic)
            
            // Write session name to cache list
            
            var cached = UserDefaults.standard.array(forKey: "localCached") as? [String] ?? []
            cached.append(path.lastPathComponent)
            
            UserDefaults.standard.set(cached, forKey: "localCached")
            UserDefaults.standard.synchronize()
        }
        catch {
            print(error)
        }
        
        // End of Save session
    }
    
    
    // MARK: - Predefined Tasks
    
    private func consentTask() -> ORKOrderedTask {
        
        let document = ORKConsentDocument()
        document.title = "MyTouch 使用同意書"
        
        /*
         * Supported types (in ResearchKit recommanded order):
         * .overview, .dataGathering, .privacy, .dataUse, .timeCommitment, .studySurvey, .studyTasks, .withdrawing
         */
        let sectionTypes: [ORKConsentSectionType] = [
            .overview,
            .dataGathering,
            .privacy,
            .studySurvey,
            .withdrawing
        ]
        
        let consentSections: [ORKConsentSection] = sectionTypes.map { contentSectionType in
            let consentSection = ORKConsentSection(type: contentSectionType)
            switch contentSectionType {
            case .overview:
                consentSection.summary = "歡迎來到 MyTouch！由於檢測資料將會提供學術研究使用，於是在使用本 app 前，有以下事項須向您做說明。"
                // consentSection.content = ""
                
            case .dataGathering:
                consentSection.summary = "接下來之測驗進行方式，為進行一系列的測驗，約耗時 20 分鐘。本 app 測驗結果除了為您帶來更順暢的觸控體驗，亦會將您的測驗資料作為日後學術研究使用。"
                
            case .privacy:
                consentSection.summary = "為確保您的個人權益，我們僅將資料結果做學術上的研究使用，並不會將您的個人資料外流，或做其他商業利用。"
                
            case .studySurvey:
                consentSection.summary = "除前述測驗外，我們亦須向您蒐集個人資料（如：年齡、性別、手機、信箱、同意書簽名等），以增進日後研究之樣本蒐集。"
                
            case .withdrawing:
                consentSection.summary = "若您無法配合 MyTouch 之資料用途，我們雖深感遺憾但亦尊重您的決定。期待未來能有機會再與您合作！"
                
            default:
                break
            }
            return consentSection
        }
        
        document.sections = consentSections
        document.addSignature(ORKConsentSignature(forPersonWithTitle: "User", dateFormatString: nil, identifier: "signature"))
        
        var steps = [ORKStep]()
        
        let visualConsentStep = ORKVisualConsentStep(identifier: "visualConsent", document: document)
        steps.append(visualConsentStep)
        
        let signature = document.signatures?.first
        let reviewStep = ORKConsentReviewStep(identifier: "review", signature: signature, in: document)
        reviewStep.text = "檢閱同意書" // "Review the consent"
        reviewStep.reasonForConsent = "MyTouch 使用同意書"// "Consent to join the Research Study."
        steps.append(reviewStep)
        
        let completionStep = ORKCompletionStep(identifier: "completion")
        completionStep.title = "歡迎" // "Welcome"
        completionStep.text = "謝謝您" // "Thank you."
        steps.append(completionStep)
        
        return ORKOrderedTask(identifier: "consentTask", steps: steps)
    }
    
    private func surveyTask() -> ORKOrderedTask {
        
        var steps = [ORKStep]()
        
        let instructionStep = ORKInstructionStep(identifier: "intro")
        instructionStep.title = "Test Survey"
        instructionStep.text = "Answer three questions to complete the survey."
        steps += [instructionStep]
        
        let emailFormat = ORKEmailAnswerFormat()
        
        let nameAnswerFormat = ORKTextAnswerFormat(maximumLength: 100)
        nameAnswerFormat.multipleLines = false
        
        let birthYearFormat = ORKNumericAnswerFormat.integerAnswerFormat(withUnit: nil)
        birthYearFormat.minimum = NSNumber(value: Calendar(identifier: .iso8601).component(.year, from: Date.distantPast))
        birthYearFormat.maximum = NSNumber(value: Calendar(identifier: .iso8601).component(.year, from: Date()))
        
        let genderFormat = ORKTextChoiceAnswerFormat(style: .singleChoice, textChoices: [
            ORKTextChoice(text: "Female", value: Subject.Gender.female.rawValue as NSString),
            ORKTextChoice(text: "Male", value: Subject.Gender.male.rawValue as NSString),
            ORKTextChoice(text: "Other", value: Subject.Gender.other.rawValue as NSString),
        ])
        
        let dominantHandFormat = ORKTextChoiceAnswerFormat(style: .singleChoice, textChoices: [
            ORKTextChoice(text: "Left Handed", value: Subject.DominantHand.left.rawValue as NSString),
            ORKTextChoice(text: "Right Handed", value: Subject.DominantHand.right.rawValue as NSString),
            ORKTextChoice(text: "Both", value: Subject.DominantHand.both.rawValue as NSString),
            ORKTextChoice(text: "None", value: Subject.DominantHand.none.rawValue as NSString)
        ])
        
        steps += [
            ORKQuestionStep(identifier: "email", title: "Information", question: "email address", answer: emailFormat),
            ORKQuestionStep(identifier: "name", title: "Information", question: "name", answer: nameAnswerFormat),
            ORKQuestionStep(identifier: "birth", title: "Information", question: "birth year", answer: birthYearFormat),
            ORKQuestionStep(identifier: "gender", title: "Information", question: "gender", answer: genderFormat),
            ORKQuestionStep(identifier: "hand", title: "Information", question: "dominant hand", answer: dominantHandFormat)
        ]
        
        let symptomFormat = ORKTextChoiceAnswerFormat(style: .multipleChoice, textChoices: [
            ORKTextChoice(text: "Slow Movement", value: Subject.Symptom.slowMovement.rawValue as NSNumber),
            ORKTextChoice(text: "Rapid Fatigue", value: Subject.Symptom.rapidFatigue.rawValue as NSNumber),
            ORKTextChoice(text: "Poor Coordination", value: Subject.Symptom.poorCoordination.rawValue as NSNumber),
            ORKTextChoice(text: "Low Strength", value: Subject.Symptom.lowStrength.rawValue as NSNumber),
            ORKTextChoice(text: "Difficulty Gripping", value: Subject.Symptom.difficultyGripping.rawValue as NSNumber),
            ORKTextChoice(text: "Difficulty Holding", value: Subject.Symptom.difficultyHolding.rawValue as NSNumber),
            ORKTextChoice(text: "Tremor", value: Subject.Symptom.tremor.rawValue as NSNumber),
            ORKTextChoice(text: "Spasm", value: Subject.Symptom.spasm.rawValue as NSNumber),
            ORKTextChoice(text: "Lack of Sensation", value: Subject.Symptom.lackOfSensation.rawValue as NSNumber),
            ORKTextChoice(text: "Difficulty Controlling Direction", value: Subject.Symptom.difficultyControllingDirection.rawValue as NSNumber),
            ORKTextChoice(text: "Difficulty Controlling Distance", value: Subject.Symptom.difficultyControllingDistance.rawValue as NSNumber),
        ])
        
        steps += [
            ORKQuestionStep(identifier: "symptom", title: "Symptom", question: "Your symptoms", answer: symptomFormat)
        ]
        
        
        let completionStep = ORKCompletionStep(identifier: "summary")
        completionStep.title = "Thank You!!"
        completionStep.text = "You have completed the survey"
        steps += [completionStep]
        
        
        // skip name question if age is 20
        
//        let predicate = ORKResultPredicate.predicateForNumericQuestionResult(with: ORKResultSelector(resultIdentifier: ageQuestionStep.identifier), expectedAnswer: 20)
//        let rule = ORKPredicateStepNavigationRule(resultPredicatesAndDestinationStepIdentifiers: [(predicate, completionStep.identifier)])
//
//        let task = ORKNavigableOrderedTask(identifier: "survey", steps: steps)
//        task.setNavigationRule(rule, forTriggerStepIdentifier: ageQuestionStep.identifier)
        
        return ORKOrderedTask(identifier: "survey", steps: steps)
    }
    
    private func activityTask() -> ORKOrderedTask {
        return ORKOrderedTask.touchAbilityTask(withIdentifier: "touch", intendedUseDescription: nil, taskOptions: [.tap], options: [])
    }
}

extension SessionController {
    
    enum State {
        case initial
        case success(sessions: [Session])
        case error(error: Error)
        
        var sessions: [Session]? {
            if case .success(let sessions) = self { return sessions }
            return nil
        }
        
        var error: Error? {
            if case .error(let error) = self { return error }
            return nil
        }
    }
}


// MARK: - ORKTaskViewControllerDelegate

extension SessionController: ORKTaskViewControllerDelegate {
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
        // Handle task view controller results accordingly.
        
        if taskViewController.taskRunUUID == TaskUUID.consentUUID {
            handleConsentDidFinish(taskViewController, didFinishWith: reason, error: error)
        }
        else if taskViewController.taskRunUUID == TaskUUID.surveyUUID {
            handleSurveyDidFinish(taskViewController, didFinishWith: reason, error: error)
        }
        else if taskViewController.taskRunUUID == TaskUUID.activityUUID {
            handleActivityDidFinish(taskViewController, didFinishWith: reason, error: error)
        }
        else {
            taskViewController.dismiss(animated: true, completion: nil)
        }
    }
}
