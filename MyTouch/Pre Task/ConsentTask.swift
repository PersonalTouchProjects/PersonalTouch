//
//  ConsentTask.swift
//  MyTouch
//
//  Created by Peng Yi Hao on 2018/7/9.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import ResearchKit

public var ConsentTask: ORKOrderedTask {
    
    // A step, represented by ORKStep, can be a question, an active test, or a simple instruction.
    // As we are going to present multiple steps, we first create an empty array of ORKStep. We will add three tasks:
    
    var steps = [ORKStep]()
    
    
    
    // Consent: The information regarding the research study in order to obtain his/her consent.
    // ORKConsentDocument contains section types which can be defined as ORKConsentSectionType.
    let Document = ORKConsentDocument()
    Document.title = "Test Consent"
    
    
    
    // ORKConsentSect≈ionType enumerates the predefined visual consent sections available in the ResearchKit framework
    let sectionTypes: [ORKConsentSectionType] = [
        .overview,
        .dataGathering,
        .privacy,
        .dataUse,
        .timeCommitment,
        .studySurvey,
        .studyTasks,
        .withdrawing
    ]
    
    
    // The ORKConsentSection class represents one section in a consent document.
    let consentSections: [ORKConsentSection] = sectionTypes.map { contentSectionType in
        let consentSection = ORKConsentSection(type: contentSectionType)
        
        // we are also adding summary and content for particular section type by iterating through array of sectionTypes
        consentSection.summary = "Complete the study"
        consentSection.content = "This survey will ask you three questions and you will also measure your tapping speed by performing a small activity."
        return consentSection
    }
    
    Document.sections = consentSections
    
    // Now we will add signature to our document.
    // The ORKConsentSignature class represents a signature in as ORKConsentDocument object
    Document.addSignature(ORKConsentSignature(forPersonWithTitle: nil, dateFormatString: nil, identifier: "UserSignature"))
    
    
    
    // Visual Consent
    
    // The ORKVisualConsentStep object is used to present a series of simple graphics to help participants understand the content of an informed consent document.
    let visualConsentStep = ORKVisualConsentStep(identifier: "VisualConsent", document: Document)
    steps += [visualConsentStep]
    
    // Signature
    
    // The ORKConsentReviewStep object is used to display the consent document for review.  The user is asked to enter name and draw the signature. Name and signature entry is optional
    let signature = Document.signatures!.first! as ORKConsentSignature
    
    signature.requiresName = false
    signature.requiresSignatureImage = false
    
    let reviewConsentStep = ORKConsentReviewStep(identifier: "Review", signature: signature, in: Document)
    reviewConsentStep.text = "Review the consent"
    reviewConsentStep.reasonForConsent = "Consent to join the Research Study."
    
    steps += [reviewConsentStep]
    
    
    
    // Completion
    
    // This step will be displayed to user on completion of the review task.
    let completionStep = ORKCompletionStep(identifier: "CompletionStep")
    completionStep.title = "Welcome"
    completionStep.text = "Thank you for joining this study."
    steps += [completionStep]
    
    
    
    return ORKOrderedTask(identifier: "ConsentTask", steps: steps)
}

