//
//  HomeTabBarController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/1/16.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit
import ResearchKit

extension Notification.Name {
    static let sessionsDidLoad = Notification.Name("sessionsDidLoad")
    static let sessionDidUpload = Notification.Name("sessionDidUpload")
}


class HomeTabBarController: UITabBarController {

    // MARK: - UIViewController
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return [.landscapeLeft, .landscapeRight]
        default:
            return [.portrait]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.isTranslucent = false
        tabBar.tintColor = UIColor(hex: 0x00b894)
        tabBar.unselectedItemTintColor = UIColor(hex: 0xb2bec3)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.reloadSessions()
        }
    }
    
    
    // MARK: - Sessions
    
    private(set) var isLoaded: Bool = false
    private(set) var sessions: [Session] = []
    private(set) var error: Error?
    
    
    // MARK: - API
    
    private let client = APIClient()
    
    func reloadSessions() {
        
        client.loadSessions { (sessions, error) in
            
            self.isLoaded = true
            
            sessions?.forEach {
                do {
                    try $0.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            self.sessions = Session.locals().sorted { $0.start > $1.start }
            self.error = error
            
            
            let notification = Notification(name: .sessionsDidLoad, object: self, userInfo: nil)
            NotificationQueue.default.enqueue(notification, postingStyle: .asap)
        }
    }
    
    func uploadSession(_ session: Session, completion: @escaping (Session?, Error?) -> Void) {
        
        client.uploadSession(session, completion: completion)
        
//        client.uploadSession(session) { (session, error) in
//
////            print(session, error)
////
////            let notification = Notification(name: .sessionDidUpload, object: self, userInfo: nil)
////            NotificationQueue.default.enqueue(notification, postingStyle: .asap)
//
//            if let error = error {
//
//                let alertController = UIAlertController(title: "錯誤", message: error.localizedDescription, preferredStyle: .alert)
//                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//
//                alertController.addAction(action)
//                self.present(alertController, animated: true, completion: nil)
//
//            }
//            else {
//                self.reloadSessions()
//            }
//        }
    }
    
    // MARK: - Research FLow

    private var currentSession: Session?
    
    func presentConsent() {
        let taskViewController = ORKTaskViewController(task: consentTask(), taskRun: consentID)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
    
    func presentSurveyAndActivity() {
        let taskViewController = ORKTaskViewController(task: surveyTask(), taskRun: surveyID)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
    
    private func presentActivity(with session: Session) {
        
        self.currentSession = session
        
        let taskViewController = ORKTaskViewController(task: activityTask(), taskRun: activityID)
        taskViewController.delegate = self
        
        present(taskViewController, animated: true) {
            self.currentSession?.start = Date()
        }
    }
    
    private func consentDidFinish(taskViewController: ORKTaskViewController, with reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
        taskViewController.dismiss(animated: true, completion: nil)
    }
    
    private func surveyDidFinish(taskViewController: ORKTaskViewController, with reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
        switch reason {
        case .completed:
            
            // Generate subject object
            var subject = Subject()
            
            if let birthResult = taskViewController.result.stepResult(forStepIdentifier: "birth")?.result(forIdentifier: "birth") as? ORKNumericQuestionResult {
                subject.birthYear = birthResult.numericAnswer!.intValue
            }
            
            if let nameResult = taskViewController.result.stepResult(forStepIdentifier: "name")?.result(forIdentifier: "name") as? ORKTextQuestionResult {
                subject.name = nameResult.textAnswer!
            }
            
            if let genderResult = taskViewController.result.stepResult(forStepIdentifier: "gender")?.result(forIdentifier: "gender") as? ORKChoiceQuestionResult {
                if let answer = genderResult.choiceAnswers?.first as? String {
                    subject.gender = Subject.Gender(rawValue: answer) ?? .other
                }
            }
            
            if let handResult = taskViewController.result.stepResult(forStepIdentifier: "hand")?.result(forIdentifier: "hand") as? ORKChoiceQuestionResult {
                if let answer = handResult.choiceAnswers?.first as? String {
                    subject.dominantHand = Subject.DominantHand(rawValue: answer) ?? .none
                }
            }
            
            if let impairmentResult = taskViewController.result.stepResult(forStepIdentifier: "impairment")?.result(forIdentifier: "impairment") as? ORKChoiceQuestionResult {
                if let answer = impairmentResult.choiceAnswers?.first as? String {
                    subject.impairment = Subject.Impairment(rawValue: answer) ?? .none
                }
            }
            
            if let symptomResult = taskViewController.result.stepResult(forStepIdentifier: "symptom")?.result(forIdentifier: "symptom") as? ORKChoiceQuestionResult {
                if let answer = symptomResult.choiceAnswers as? [UInt] {
                    for n in answer {
                        switch Subject.Symptom(rawValue: n) {
                        case .slowMovement: subject.slowMovement = true
                        case .rapidFatigue: subject.rapidFatigue = true
                        case .poorCoordination: subject.poorCoordination = true
                        case .lowStrength: subject.lowStrength = true
                        case .difficultyGripping: subject.difficultyGripping = true
                        case .difficultyHolding: subject.difficultyHolding = true
                        case .tremor: subject.tremor = true
                        case .spasm: subject.spasm = true
                        case .lackOfSensation: subject.lackOfSensation = true
                        case .difficultyControllingDirection: subject.difficultyControllingDirection = true
                        case .difficultyControllingDistance: subject.difficultyControllingDistance = true
                        default: break
                        }
                    }
                }
            }
            
            // End of generate subject
            
            taskViewController.dismiss(animated: true) {
                self.presentActivity(with: Session(deviceInfo: DeviceInfo(), subject: subject))
            }
            
        default:
            self.currentSession = nil
            taskViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    private func activityDidFinish(taskViewController: ORKTaskViewController, with reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
        guard var session = currentSession else {
            return
        }
        
        switch reason {
        case .completed:
            
            session.end = Date()
            
            if let result = taskViewController.result.stepResult(forStepIdentifier: "touchAbilityTap")?.result(forIdentifier: "touchAbilityTap") as? ORKTouchAbilityTapResult {
                session.tap = TapTask(result: result)
            }
            
            if let result = taskViewController.result.stepResult(forStepIdentifier: "touchAbilityLongPress")?.result(forIdentifier: "touchAbilityLongPress") as? ORKTouchAbilityLongPressResult {
                session.longPress = LongPressTask(result: result)
            }
            
            if let result = taskViewController.result.stepResult(forStepIdentifier: "touchAbilitySwipe")?.result(forIdentifier: "touchAbilitySwipe") as? ORKTouchAbilitySwipeResult {
                session.swipe = SwipeTask(result: result)
            }
            
            if let result = taskViewController.result.stepResult(forStepIdentifier: "touchAbilityHorizontalScroll")?.result(forIdentifier: "touchAbilityHorizontalScroll") as? ORKTouchAbilityScrollResult {
                session.horizontalScroll = ScrollTask(result: result)
            }
            
            if let result = taskViewController.result.stepResult(forStepIdentifier: "touchAbilityVerticalScroll")?.result(forIdentifier: "touchAbilityVerticalScroll") as? ORKTouchAbilityScrollResult {
                session.verticalScroll = ScrollTask(result: result)
            }
            
            if let result = taskViewController.result.stepResult(forStepIdentifier: "touchAbilityPinch")?.result(forIdentifier: "touchAbilityPinch") as? ORKTouchAbilityPinchResult {
                session.pinch = PinchTask(result: result)
            }
            
            if let result = taskViewController.result.stepResult(forStepIdentifier: "touchAbilityRotation")?.result(forIdentifier: "touchAbilityrotation") as? ORKTouchAbilityRotationResult {
                session.rotation = RotationTask(result: result)
            }
            
            
            // error alert closure
            func alert(error: Error, vc: UIViewController) {
                
                let alertController = UIAlertController(
                    title: "錯誤",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(
                    title: "OK",
                    style: .default,
                    handler: nil)
                )
                
                // present error message, DO NOT dismiss task view controller
                vc.present(alertController, animated: true, completion: nil)
            }
            
            do {
                // Save session as local cache first
                try session.save()
                
                // upload it to the server
                uploadSession(session) { session, error in
                    
                    // if error occured, present error message
                    if let error = error {
                        alert(error: error, vc: taskViewController)
                    }
                    
                    // else, dismiss task view controller and refetch sessions from server
                    else {
                        taskViewController.dismiss(animated: true) {
                            self.reloadSessions()
                        }
                    }
                }
            }
            catch {
                
                // error occured when saving session, present error and DO NOT dismiss task view controller
                alert(error: error, vc: taskViewController)
            }
            
        default:
            currentSession = nil
            taskViewController.dismiss(animated: true, completion: nil)
            
        }
    }
}


// MARK: - ORKTaskViewControllerDelegate

extension HomeTabBarController: ORKTaskViewControllerDelegate {
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
        switch taskViewController.taskRunUUID {
        case consentID:
            consentDidFinish(taskViewController: taskViewController, with: reason, error: error)
            
        case surveyID:
            surveyDidFinish(taskViewController: taskViewController, with: reason, error: error)
            
        case activityID:
            activityDidFinish(taskViewController: taskViewController, with: reason, error: error)
            
        default:
            break
        }
    }
}


// MARK: - ResearchKit Flow

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
    
    // let emailFormat = ORKEmailAnswerFormat()
    
    // name
    let nameAnswerFormat = ORKTextAnswerFormat(maximumLength: 100)
    nameAnswerFormat.multipleLines = false
    steps.append(ORKQuestionStep(identifier: "name", title: "Information", question: "name", answer: nameAnswerFormat))
    
    
    // birth year
    let birthYearFormat = ORKNumericAnswerFormat.integerAnswerFormat(withUnit: nil)
    birthYearFormat.minimum = NSNumber(value: Calendar(identifier: .iso8601).component(.year, from: Date.distantPast))
    birthYearFormat.maximum = NSNumber(value: Calendar(identifier: .iso8601).component(.year, from: Date()))
    steps.append(ORKQuestionStep(identifier: "birth", title: "Information", question: "birth year", answer: birthYearFormat))
    
    
    // gender
    let genderFormat = ORKTextChoiceAnswerFormat(style: .singleChoice, textChoices: [
        ORKTextChoice(text: "Female", value: Subject.Gender.female.rawValue as NSString),
        ORKTextChoice(text: "Male", value: Subject.Gender.male.rawValue as NSString),
        ORKTextChoice(text: "Other", value: Subject.Gender.other.rawValue as NSString),
    ])
    steps.append(ORKQuestionStep(identifier: "gender", title: "Information", question: "gender", answer: genderFormat))
    
    
    // dominant hand
    let dominantHandFormat = ORKTextChoiceAnswerFormat(style: .singleChoice, textChoices: [
        ORKTextChoice(text: "Left Handed", value: Subject.DominantHand.left.rawValue as NSString),
        ORKTextChoice(text: "Right Handed", value: Subject.DominantHand.right.rawValue as NSString),
        ORKTextChoice(text: "Both", value: Subject.DominantHand.both.rawValue as NSString),
        ORKTextChoice(text: "None", value: Subject.DominantHand.none.rawValue as NSString)
    ])
    steps.append(ORKQuestionStep(identifier: "hand", title: "Information", question: "dominant hand", answer: dominantHandFormat))
    
    
    // health impairment
    let impairmentFormat = ORKTextChoiceAnswerFormat(style: .singleChoice, textChoices: [
        ORKTextChoice(text: "None", value: Subject.Impairment.none.rawValue as NSString),
        ORKTextChoice(text: "Parkinson's", value: Subject.Impairment.parkinsons.rawValue as NSString),
        ORKTextChoice(text: "Cerebral Palsy", value: Subject.Impairment.cerebralPalsy.rawValue as NSString),
        ORKTextChoice(text: "Muscular Dystrophy", value: Subject.Impairment.muscularDystrophy.rawValue as NSString),
        ORKTextChoice(text: "Spinal Cord Injury", value: Subject.Impairment.spinalCordInjury.rawValue as NSString),
        ORKTextChoice(text: "Tetraplegia", value: Subject.Impairment.tetraplegia.rawValue as NSString),
        ORKTextChoice(text: "Friedreichs Ataxia", value: Subject.Impairment.friedreichsAtaxia.rawValue as NSString),
        ORKTextChoice(text: "Multiple Sclerosis", value: Subject.Impairment.multipleSclerosis.rawValue as NSString),
        ORKTextChoice(text: "Others", value: Subject.Impairment.others.rawValue as NSString),
    ])
    steps.append(ORKQuestionStep(identifier: "impairment", title: "Impairment", question: "Your impairment", answer: impairmentFormat))
    
    // health impairment free text
    let impairmentFreeTextFormat = ORKTextAnswerFormat(maximumLength: 200)
    impairmentFreeTextFormat.multipleLines = true
    steps.append(ORKQuestionStep(identifier: "impairmentFreeText", title: "Impairment", question: "Your impairment", answer: impairmentFreeTextFormat))
    
    // symptom
    let symptomFormat = ORKTextChoiceAnswerFormat(style: .multipleChoice, textChoices: [
        ORKTextChoice(text: "None", value: 0 as NSNumber),
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
    steps.append(ORKQuestionStep(identifier: "symptom", title: "Symptom", question: "Your symptoms", answer: symptomFormat))
    
    
    let completionStep = ORKCompletionStep(identifier: "summary")
    completionStep.title = "Thank You!!"
    completionStep.text = "You have completed the survey"
    steps += [completionStep]
    
    return OrderedTask(identifier: "survey", steps: steps)
}

private func activityTask() -> ORKOrderedTask {
    return ORKOrderedTask.touchAbilityTask(withIdentifier: "touch", intendedUseDescription: nil, taskOptions: [.tap], options: [])
}

private let consentID = UUID()

private let surveyID = UUID()

private let activityID = UUID()


// MARK: - Private OrderedTask for skipping steps

private class OrderedTask: ORKOrderedTask {
    
    override func step(after step: ORKStep?, with result: ORKTaskResult) -> ORKStep? {
        
        guard step?.identifier == "impairment" else {
            return super.step(after: step, with: result)
        }
        
        guard let choice = result.stepResult(forStepIdentifier: "impairment")?.result(forIdentifier: "impairment") as? ORKChoiceQuestionResult else {
            return super.step(after: step, with: result)
        }
        
        guard let answer = choice.choiceAnswers?.first as? String else {
            return super.step(after: step, with: result)
        }
        
        if answer == "others" {
            return self.step(withIdentifier: "impairmentFreeText")
        } else {
            return self.step(withIdentifier: "symptom")
        }
    }
    
    override func step(before step: ORKStep?, with result: ORKTaskResult) -> ORKStep? {
        
        guard step?.identifier == "symptom" else {
            return super.step(before: step, with: result)
        }
        
        guard let choice = result.stepResult(forStepIdentifier: "impairment")?.result(forIdentifier: "impairment") as? ORKChoiceQuestionResult else {
            return super.step(before: step, with: result)
        }
        
        guard let answer = choice.choiceAnswers?.first as? String else {
            return super.step(before: step, with: result)
        }
        
        if answer == "others" {
            return self.step(withIdentifier: "impairmentFreeText")
        } else {
            return self.step(withIdentifier: "impairment")
        }
    }
}
