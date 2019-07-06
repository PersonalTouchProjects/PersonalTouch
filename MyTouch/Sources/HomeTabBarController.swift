//
//  HomeTabBarController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/1/16.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit
import ResearchKit
import UserNotifications

extension Notification.Name {
    static let sessionsDidLoad = Notification.Name("sessionsDidLoad")
    static let sessionDidUpload = Notification.Name("sessionDidUpload")
}

/// The root view controller of This app.
///
/// It handles API client actions and store the sessions returned by the client.
///
/// It also handles ResearchKit-related flow, such as creating and handling consent, survey, and active task.
class HomeTabBarController: UITabBarController {

    // MARK: - UIViewController
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        // Display in landscape mode in iPad and in protrait mode on other devices (currently iPhone only).
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return [.landscapeLeft, .landscapeRight]
        default:
            return [.portrait]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up tab bar appearance.
        tabBar.isTranslucent = false
        tabBar.tintColor = UIColor(hex: 0x00b894)
        tabBar.unselectedItemTintColor = UIColor(hex: 0xb2bec3)
        
        // Set up notification observation.
        NotificationCenter.default.addObserver(self, selector: #selector(handleApplicationWillEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleApplicationWillResignActive(_:)), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleApplicationWillResignActive(_:)), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // If not consented, present consent form, else upload cached sessions if needed.
        if UserDefaults.standard.bool(forKey: UserDefaults.Key.consented) == false {
            presentConsent()
        } else {
            uploadCachedSessions()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Sessions
    
    private(set) var isSessionsLoaded: Bool = false
    private(set) var sessions: [Session] = []
    private(set) var error: Error?
    
    
    // MARK: - API
    
    private let client = APIClient()
    
    func reloadSessions(completion: (() -> Void)? = nil) {
        
        client.loadSessions { (sessions, error) in
            
            self.isSessionsLoaded = true
            
            // save sessions in storage
            sessions?.forEach {
                do {
                    try $0.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            // sort sessions by date, newest on top
            self.sessions = Session.locals().sorted { $0.start > $1.start }
            self.error = error
            
            // notify everyone that sessions are loadeds
            let notification = Notification(name: .sessionsDidLoad, object: self, userInfo: nil)
            NotificationQueue.default.enqueue(notification, postingStyle: .asap)
            
            completion?()
        }
    }
    
    func uploadSession(_ session: Session, completion: @escaping (Session?, Error?) -> Void) {
        client.uploadSession(session, completion: completion)
    }
    
    func uploadCachedSessions() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.reloadSessions {
                
                for cache in self.sessions.filter({ $0.state == .local }) {
                    self.uploadSession(cache) { (_, _) in
                        self.reloadSessions()
                    }
                }
            }
        }
    }
    
    
    // MARK: - Handle App State Notification
    
    @objc private func handleApplicationWillEnterForeground(_ notification: Notification) {
        uploadCachedSessions()
    }
    
    @objc private func handleApplicationWillResignActive(_ notification: Notification) {
        
        // If any local cached session exists, schedule an local notification.
        if self.sessions.filter({ $0.state == .local }).count > 0 {
            
            let content = UNMutableNotificationContent()
            content.title = NSLocalizedString("LOCAL_SESSIONS_NOTIFICATION_TITLE", comment: "local sessions notification title")
            content.body = NSLocalizedString("LOCAL_SESSIONS_NOTIFICATION_BODY", comment: "local sessions notification body")
            
            // trigger every 15:30
            var dateComponents = DateComponents()
            dateComponents.hour = 15
            dateComponents.minute = 30
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "test", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    // MARK: - Research FLow

    private var currentSession: Session?
    
    func presentConsent() {
        let taskViewController = ORKTaskViewController(task: consentTask(), taskRun: consentID)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
    
    func presentSurveyAndActivity() {
        
        var subject: Subject?
        if let data = UserDefaults.standard.data(forKey: UserDefaults.Key.latestSubject) {
            subject = try? APIClient.decoder.decode(Subject.self, from: data)
        }

        // if latest subject exists, ask user if he/she wants to auto fill in with it.
        if let subject = subject {
            
            // present subject summary view controller
            let vc = SubjectSummaryViewController(subject: subject) { [unowned self] vc, autoFillIn in
                
                // dismiss subject summary view controller
                vc.dismiss(animated: true) {
                    
                    // if should auto fill in, present activity flow with that subject
                    if autoFillIn {
                        self.presentActivity(with: Session(deviceInfo: DeviceInfo(), subject: subject))
                    }
                    
                    // else, present subject survey
                    else {
                        let taskViewController = ORKTaskViewController(task: surveyTask(), taskRun: surveyID)
                        taskViewController.delegate = self
                        self.present(taskViewController, animated: true, completion: nil)
                    }
                }
            }
            
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = self
            present(vc, animated: true, completion: nil)
        }
            
        // latest subject not exists, present subject survey directly
        else {
            let taskViewController = ORKTaskViewController(task: surveyTask(), taskRun: surveyID)
            taskViewController.delegate = self
            present(taskViewController, animated: true, completion: nil)
        }
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
        
        if reason == .completed {
            UserDefaults.standard.set(true, forKey: UserDefaults.Key.consented)
            UserDefaults.standard.synchronize()
            
            taskViewController.dismiss(animated: true, completion: nil)
        } else {
            
            let title = NSLocalizedString("OOPS", comment: "")
            let message = NSLocalizedString("MUST_CONSENT_MESSAGE", comment: "")
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
            
            alertController.addAction(action)
            taskViewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func surveyDidFinish(taskViewController: ORKTaskViewController, with reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
        switch reason {
        case .completed:
            
            if let autoFillResult = taskViewController.result.stepResult(forStepIdentifier: "autoFill")?.result(forIdentifier: "autoFill") as? ORKBooleanQuestionResult,
                autoFillResult.booleanAnswer == NSNumber(booleanLiteral: true) {
                
                let data = UserDefaults.standard.data(forKey: UserDefaults.Key.latestSubject)
                assert(data != nil, "Cannot load latest subject")
                
                do {
                    let subject = try APIClient.decoder.decode(Subject.self, from: data!)
                    taskViewController.dismiss(animated: true) {
                        self.presentActivity(with: Session(deviceInfo: DeviceInfo(), subject: subject))
                    }
                } catch {
                    print(error)
                    fatalError()
                }
                
                return
            }
            
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
                        case .slowMovement:                   subject.slowMovement = true
                        case .rapidFatigue:                   subject.rapidFatigue = true
                        case .poorCoordination:               subject.poorCoordination = true
                        case .lowStrength:                    subject.lowStrength = true
                        case .difficultyGripping:             subject.difficultyGripping = true
                        case .difficultyHolding:              subject.difficultyHolding = true
                        case .tremor:                         subject.tremor = true
                        case .spasm:                          subject.spasm = true
                        case .lackOfSensation:                subject.lackOfSensation = true
                        case .difficultyControllingDirection: subject.difficultyControllingDirection = true
                        case .difficultyControllingDistance:  subject.difficultyControllingDistance = true
                        default: break
                        }
                    }
                }
            }
            
            do {
                let data = try APIClient.encoder.encode(subject)
                UserDefaults.standard.set(data, forKey: UserDefaults.Key.latestSubject)
                UserDefaults.standard.synchronize()
            }
            catch {
                print(error)
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
            
            
            // upload it to the server
            uploadSession(session) { uploaded, error in
                
                // if success, save and reload
                if let uploaded = uploaded {
                    
                    try? uploaded.save()
                    taskViewController.dismiss(animated: true) {
                        self.reloadSessions()
                    }
                }
                
                // if error occured, present error message
                else if let error = error {
                    
                    let alertController = UIAlertController(
                        title: NSLocalizedString("ERROR", comment: ""),
                        message: error.localizedDescription,
                        preferredStyle: .alert
                    )
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { action in
                        
                        // try to save local cache after presenting upload error meesage
                        do {
                            // Save session as local cache
                            try session.save()
                            taskViewController.dismiss(animated: true) {
                                self.reloadSessions()
                            }
                            
                        } catch {
                            
                            // error occured when saving session, present error and DO NOT dismiss task view controller
                            let alertController = UIAlertController(
                                title: NSLocalizedString("ERROR", comment: ""),
                                message: error.localizedDescription,
                                preferredStyle: .alert
                            )
                            alertController.addAction(UIAlertAction(
                                title: NSLocalizedString("OK", comment: ""),
                                style: .default,
                                handler: nil)
                            )
                            
                            // present error message, DO NOT dismiss task view controller
                            taskViewController.present(alertController, animated: true, completion: nil)
                        }
                    })
                    
                    // present error message, DO NOT dismiss task view controller
                    taskViewController.present(alertController, animated: true, completion: nil)
                }
            }
            
        case .discarded:
            
            let title = NSLocalizedString("FINISH_EXAM_QUESTION_TITLE", comment: "")
            let message = NSLocalizedString("FINISH_EXAM_QUESTION_BODY", comment: "")
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let confirm = UIAlertAction(title: NSLocalizedString("END", comment: ""), style: .destructive) { _ in
                self.currentSession = nil
                taskViewController.dismiss(animated: true, completion: nil)
            }
            let cancel = UIAlertAction(title: NSLocalizedString("CONTINUE_EXAM", comment: ""), style: .default, handler: nil)
            
            alertController.addAction(confirm)
            alertController.addAction(cancel)
            
            taskViewController.present(alertController, animated: true, completion: nil)
            
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

extension HomeTabBarController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        if presented is SubjectSummaryViewController {
            return CenterModalPresentationController(presentedViewController: presented, presenting: presenting)
        }
        
        return nil
    }
}


// MARK: - ResearchKit Flow

private func consentTask() -> ORKOrderedTask {
    
    let document = ORKConsentDocument()
    document.title = NSLocalizedString("MYTOUCH_CONSENT_DOCUMENT", comment: "")
    
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
            consentSection.summary = NSLocalizedString("MYTOUCH_CONSENT_OVERVIEW_SUMMARY", comment: "")
            // consentSection.content = ""
            
        case .dataGathering:
            consentSection.summary = NSLocalizedString("MYTOUCH_CONSENT_DATA_GATHERING_SUMMARY", comment: "")
            
        case .privacy:
            consentSection.summary = NSLocalizedString("MYTOUCH_CONSENT_PRIVACY_SUMMARY", comment: "")
            
        case .studySurvey:
            consentSection.summary = NSLocalizedString("MYTOUCH_CONSENT_STUDY_SURVEY_SUMMARY", comment: "")
            
        case .withdrawing:
            consentSection.summary = NSLocalizedString("MYTOUCH_CONSENT_WITHDRAWING_SUMMARY", comment: "")
            
        default:
            break
        }
        return consentSection
    }
    
    document.sections = consentSections
    document.addSignature(ORKConsentSignature(forPersonWithTitle: NSLocalizedString("MYOTUCH_USER_TITLE", comment: ""), dateFormatString: nil, identifier: "signature"))
    
    var steps = [ORKStep]()
    
    let visualConsentStep = ORKVisualConsentStep(identifier: "visualConsent", document: document)
    steps.append(visualConsentStep)
    
//    let signature = document.signatures?.first
//    let reviewStep = ORKConsentReviewStep(identifier: "review", signature: signature, in: document)
//    reviewStep.text = "檢閱同意書" // "Review the consent"
//    reviewStep.reasonForConsent = "MyTouch 使用同意書"// "Consent to join the Research Study."
//    steps.append(reviewStep)
    
    let completionStep = ORKCompletionStep(identifier: "completion")
    completionStep.title = NSLocalizedString("WELCOME", comment: "")
    completionStep.text = NSLocalizedString("THANK_YOU", comment: "")
    steps.append(completionStep)
    
    return ORKOrderedTask(identifier: "consentTask", steps: steps)
}

private func surveyTask(with subject: Subject? = nil) -> ORKOrderedTask {
    
    var steps = [ORKStep]()
    
    let instructionStep = ORKInstructionStep(identifier: "intro")
    instructionStep.title = NSLocalizedString("SURVEY_INSTRUCTION_TITLE", comment: "")
    instructionStep.text = NSLocalizedString("SURVEY_INSTRUCTION_TEXT", comment: "")
    steps += [instructionStep]
    
    
    /* skipping name
    // name
    let nameAnswerFormat = ORKTextAnswerFormat(maximumLength: 100)
    nameAnswerFormat.multipleLines = false
    steps.append(ORKQuestionStep(
        identifier: "name",
        title: NSLocalizedString("SURVEY_NAME_TITLE", comment: ""),
        question: NSLocalizedString("SURVEY_NAME_QUESTION", comment: ""),
        answer: nameAnswerFormat)
    )
    */
    
    
    // birth year
    let birthYearFormat = ORKNumericAnswerFormat.integerAnswerFormat(withUnit: nil)
    birthYearFormat.minimum = NSNumber(value: Calendar(identifier: .iso8601).component(.year, from: Date.distantPast))
    birthYearFormat.maximum = NSNumber(value: Calendar(identifier: .iso8601).component(.year, from: Date()))
    steps.append(ORKQuestionStep(
        identifier: "birth",
        title: NSLocalizedString("SURVEY_BIRTH_YEAR_TITLE", comment: ""),
        question: NSLocalizedString("SURVEY_BIRTH_YEAR_QUESTION", comment: ""),
        answer: birthYearFormat)
    )
    
    
    // gender
    let genderFormat = ORKTextChoiceAnswerFormat(style: .singleChoice, textChoices: [
        ORKTextChoice(text: NSLocalizedString("GENDER_FEMALE", comment: ""), value: Subject.Gender.female.rawValue as NSString),
        ORKTextChoice(text: NSLocalizedString("GENDER_MALE", comment: ""), value: Subject.Gender.male.rawValue as NSString),
        ORKTextChoice(text: NSLocalizedString("GENDER_OTHER", comment: ""), value: Subject.Gender.other.rawValue as NSString),
    ])
    steps.append(ORKQuestionStep(
        identifier: "gender",
        title: NSLocalizedString("SURVEY_GENDER_TITLE", comment: ""),
        question: NSLocalizedString("SURVEY_GENDER_QUESTION", comment: ""),
        answer: genderFormat)
    )
    
    
    // dominant hand
    let dominantHandFormat = ORKTextChoiceAnswerFormat(style: .singleChoice, textChoices: [
        ORKTextChoice(text: NSLocalizedString("DOMINANT_HAND_LEFT", comment: ""), value: Subject.DominantHand.left.rawValue as NSString),
        ORKTextChoice(text: NSLocalizedString("DOMINANT_HAND_RIGHT", comment: ""), value: Subject.DominantHand.right.rawValue as NSString),
        ORKTextChoice(text: NSLocalizedString("DOMINANT_HAND_BOTH", comment: ""), value: Subject.DominantHand.both.rawValue as NSString),
        ORKTextChoice(text: NSLocalizedString("DOMINANT_HAND_NONE", comment: ""), value: Subject.DominantHand.none.rawValue as NSString)
    ])
    steps.append(ORKQuestionStep(
        identifier: "hand",
        title: NSLocalizedString("SURVEY_DOMINANT_HAND_TITLE", comment: ""),
        question: NSLocalizedString("SURVEY_DOMINANT_HAND_QUESTION", comment: ""),
        answer: dominantHandFormat)
    )
    
    
    // health impairment
    let impairmentFormat = ORKTextChoiceAnswerFormat(style: .singleChoice, textChoices: [
        ORKTextChoice(text: NSLocalizedString("IMPAIRMENT_NONE", comment: ""), value: Subject.Impairment.none.rawValue as NSString),
        ORKTextChoice(text: NSLocalizedString("IMPAIRMENT_PARKINSONS", comment: ""), value: Subject.Impairment.parkinsons.rawValue as NSString),
        ORKTextChoice(text: NSLocalizedString("IMPAIRMENT_CEREBRAL_PALSY", comment: ""), value: Subject.Impairment.cerebralPalsy.rawValue as NSString),
        ORKTextChoice(text: NSLocalizedString("IMPAIRMENT_MUSCULAR_DYSTROPHY", comment: ""), value: Subject.Impairment.muscularDystrophy.rawValue as NSString),
        ORKTextChoice(text: NSLocalizedString("IMPAIRMENT_SPINAL_CORD_INJURY", comment: ""), value: Subject.Impairment.spinalCordInjury.rawValue as NSString),
        ORKTextChoice(text: NSLocalizedString("IMPAIRMENT_TETRAPLEGIA", comment: ""), value: Subject.Impairment.tetraplegia.rawValue as NSString),
        ORKTextChoice(text: NSLocalizedString("IMPAIRMENT_FRIEDREICHS_ATAXIA", comment: ""), value: Subject.Impairment.friedreichsAtaxia.rawValue as NSString),
        ORKTextChoice(text: NSLocalizedString("IMPAIRMENT_MULTIPLE_SCLEROSIS", comment: ""), value: Subject.Impairment.multipleSclerosis.rawValue as NSString),
        ORKTextChoice(text: NSLocalizedString("IMPAIRMENT_OTHERS", comment: ""), value: Subject.Impairment.others.rawValue as NSString),
    ])
    steps.append(ORKQuestionStep(
        identifier: "impairment",
        title: NSLocalizedString("SURVEY_IMPAIRMENT_TITLE", comment: ""),
        question: NSLocalizedString("SURVEY_IMPAIRMENT_QUESTION", comment: ""),
        answer: impairmentFormat)
    )
    
    // health impairment free text
    let impairmentFreeTextFormat = ORKTextAnswerFormat(maximumLength: 200)
    impairmentFreeTextFormat.multipleLines = true
    steps.append(ORKQuestionStep(
        identifier: "impairmentFreeText",
        title: NSLocalizedString("SURVEY_IMPAIRMENT_TITLE", comment: ""),
        question: NSLocalizedString("SURVEY_IMPAIRMENT_QUESTION", comment: ""),
        answer: impairmentFreeTextFormat)
    )
    
    // symptom
    let symptomFormat = ORKTextChoiceAnswerFormat(style: .multipleChoice, textChoices: [
        ORKTextChoice(text: NSLocalizedString("SYMPTOM_NONE", comment: ""), value: 0 as NSNumber),
        ORKTextChoice(text: NSLocalizedString("SYMPTOM_SLOW_MOVEMENT", comment: ""), value: Subject.Symptom.slowMovement.rawValue as NSNumber),
        ORKTextChoice(text: NSLocalizedString("SYMPTOM_RAPID_FATIGUE", comment: ""), value: Subject.Symptom.rapidFatigue.rawValue as NSNumber),
        ORKTextChoice(text: NSLocalizedString("SYMPTOM_POOR_COORDINATION", comment: ""), value: Subject.Symptom.poorCoordination.rawValue as NSNumber),
        ORKTextChoice(text: NSLocalizedString("SYMPTOM_LOW_STRENGTH", comment: ""), value: Subject.Symptom.lowStrength.rawValue as NSNumber),
        ORKTextChoice(text: NSLocalizedString("SYMPTOM_DIFFICULTY_GRIPPING", comment: ""), value: Subject.Symptom.difficultyGripping.rawValue as NSNumber),
        ORKTextChoice(text: NSLocalizedString("SYMPTOM_DIFFICULTY_HOLDING", comment: ""), value: Subject.Symptom.difficultyHolding.rawValue as NSNumber),
        ORKTextChoice(text: NSLocalizedString("SYMPTOM_TREMOR", comment: ""), value: Subject.Symptom.tremor.rawValue as NSNumber),
        ORKTextChoice(text: NSLocalizedString("SYMPTOM_SPASM", comment: ""), value: Subject.Symptom.spasm.rawValue as NSNumber),
        ORKTextChoice(text: NSLocalizedString("SYMPTOM_LACK_OF_SENSATION", comment: ""), value: Subject.Symptom.lackOfSensation.rawValue as NSNumber),
        ORKTextChoice(text: NSLocalizedString("SYMPTOM_DIFFICULTY_CONTROLLING_DIRECTION", comment: ""), value: Subject.Symptom.difficultyControllingDirection.rawValue as NSNumber),
        ORKTextChoice(text: NSLocalizedString("SYMPTOM_DIFFICULTY_CONTROLLING_DISTANCE", comment: ""), value: Subject.Symptom.difficultyControllingDistance.rawValue as NSNumber),
    ])
    steps.append(ORKQuestionStep(
        identifier: "symptom",
        title: NSLocalizedString("SURVEY_SYMPTOMS_TITLE", comment: ""),
        question: NSLocalizedString("SURVEY_SYMPTOMS_QUESTION", comment: ""),
        answer: symptomFormat)
    )
    
    
    let completionStep = ORKCompletionStep(identifier: "summary")
    completionStep.title = NSLocalizedString("THANK_YOU", comment: "")
    completionStep.text = NSLocalizedString("SURVEY_COMPLETION_TEXT", comment: "")
    steps += [completionStep]
    
    return OrderedTask(identifier: "survey", steps: steps)
}

private func activityTask() -> ORKOrderedTask {
    return ORKOrderedTask.touchAbilityTask(withIdentifier: "touch", intendedUseDescription: nil, taskOptions: [.tap, .longPress, .swipe, .verticalScroll, .horizontalScroll, .pinch, .rotation], options: [])
}

private let consentID = UUID()

private let surveyID = UUID()

private let activityID = UUID()


// MARK: - Private OrderedTask for skipping steps

private class OrderedTask: ORKOrderedTask {
    
    override func step(after step: ORKStep?, with result: ORKTaskResult) -> ORKStep? {
        
        if step?.identifier == "impairment" {
            
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
        else if step?.identifier == "autoFill" {
            
            guard let choice = result.stepResult(forStepIdentifier: "autoFill")?.result(forIdentifier: "autoFill") as? ORKBooleanQuestionResult else {
                return super.step(after: step, with: result)
            }
            
            if choice.booleanAnswer == NSNumber(booleanLiteral: true) {
                return self.step(withIdentifier: "summary")
            } else {
                return super.step(after: step, with: result)
            }
        }
        
        return super.step(after: step, with: result)
    }
    
    override func step(before step: ORKStep?, with result: ORKTaskResult) -> ORKStep? {
        
        if step?.identifier == "symptom" {
            
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
        else if step?.identifier == "summary" {
            
            guard let choice = result.stepResult(forStepIdentifier: "autoFill")?.result(forIdentifier: "autoFill") as? ORKBooleanQuestionResult else {
                return super.step(before: step, with: result)
            }
            
            if choice.booleanAnswer == NSNumber(booleanLiteral: true) {
                return self.step(withIdentifier: "autoFill")
            } else {
                return super.step(before: step, with: result)
            }
        }
        
        return super.step(before: step, with: result)
    }
}
