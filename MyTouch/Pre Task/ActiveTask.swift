//
//  ActiveTask.swift
//  MyTouch
//
//  Created by Peng Yi Hao on 2018/7/9.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//


import ResearchKit
private enum Identifier {
    // Task with a form, where multiple items appear on one page.
    case formTask
    case formStep
    case formItem01
    case formItem02
    case formItem03
    
    // Survey task specific identifiers.
    case surveyTask
    case introStep
    case questionStep
    case summaryStep
    
    // Task with a Boolean question.
    case booleanQuestionTask
    case booleanQuestionStep
    
    // Task with an example of date entry.
    case dateQuestionTask
    case dateQuestionStep
    
    // Task with an example of date and time entry.
    case dateTimeQuestionTask
    case dateTimeQuestionStep
    
    // Task with an example of height entry.
    case heightQuestionTask
    case heightQuestionStep1
    case heightQuestionStep2
    case heightQuestionStep3
    
    // Task with an image choice question.
    case imageChoiceQuestionTask
    case imageChoiceQuestionStep
    
    // Task with a location entry.
    case locationQuestionTask
    case locationQuestionStep
    
    // Task with examples of numeric questions.
    case numericQuestionTask
    case numericQuestionStep
    case numericNoUnitQuestionStep
    
    // Task with examples of questions with sliding scales.
    case scaleQuestionTask
    case discreteScaleQuestionStep
    case continuousScaleQuestionStep
    case discreteVerticalScaleQuestionStep
    case continuousVerticalScaleQuestionStep
    case textScaleQuestionStep
    case textVerticalScaleQuestionStep
    
    // Task with an example of free text entry.
    case textQuestionTask
    case textQuestionStep
    
    // Task with an example of a multiple choice question.
    case textChoiceQuestionTask
    case textChoiceQuestionStep
    
    // Task with an example of time of day entry.
    case timeOfDayQuestionTask
    case timeOfDayQuestionStep
    
    // Task with an example of time interval entry.
    case timeIntervalQuestionTask
    case timeIntervalQuestionStep
    
    // Task with a value picker.
    case valuePickerChoiceQuestionTask
    case valuePickerChoiceQuestionStep
    
    // Task with an example of validated text entry.
    case validatedTextQuestionTask
    case validatedTextQuestionStepEmail
    case validatedTextQuestionStepDomain
    
    // Image capture task specific identifiers.
    case imageCaptureTask
    case imageCaptureStep
    
    // Video capture task specific identifiers.
    case VideoCaptureTask
    case VideoCaptureStep
    
    // Task with an example of waiting.
    case waitTask
    case waitStepDeterminate
    case waitStepIndeterminate
    
    // Eligibility task specific indentifiers.
    case eligibilityTask
    case eligibilityIntroStep
    case eligibilityFormStep
    case eligibilityFormItem01
    case eligibilityFormItem02
    case eligibilityFormItem03
    case eligibilityIneligibleStep
    case eligibilityEligibleStep
    
    // Consent task specific identifiers.
    case consentTask
    case visualConsentStep
    case consentSharingStep
    case consentReviewStep
    case consentDocumentParticipantSignature
    case consentDocumentInvestigatorSignature
    
    // Account creation task specific identifiers.
    case accountCreationTask
    case registrationStep
    case waitStep
    case verificationStep
    
    // Login task specific identifiers.
    case loginTask
    case loginStep
    case loginWaitStep
    
    // Passcode task specific identifiers.
    case passcodeTask
    case passcodeStep
    
    // Active tasks.
    case audioTask
    case fitnessTask
    case holePegTestTask
    case psatTask
    case reactionTime
    case shortWalkTask
    case spatialSpanMemoryTask
    case stroopTask
    case timedWalkTask
    case timedWalkWithTurnAroundTask
    case toneAudiometryTask
    case towerOfHanoi
    case tremorTestTask
    case twoFingerTappingIntervalTask
    case walkBackAndForthTask
    case kneeRangeOfMotion
    case shoulderRangeOfMotion
    case trailMaking
    
    // Video instruction tasks.
    case videoInstructionTask
    case videoInstructionStep
}

private var exampleDescription: String {
    return NSLocalizedString("Your description goes here.", comment: "")
}

public var ActiveTask: ORKOrderedTask {
    return ORKNavigableOrderedTask.holePegTest(withIdentifier: String(describing:Identifier.holePegTestTask), intendedUseDescription: exampleDescription, dominantHand: .right, numberOfPegs: 9, threshold: 0.2, rotated: false, timeLimit: 300, options: [])
    //    return ORKOrderedTask.twoFingerTappingIntervalTask(withIdentifier: "TapTask", intendedUseDescription: "Check tapping speed", duration: 6, handOptions: .both, options: ORKPredefinedTaskOption())
}

