//
//  SessionController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/2/2.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit
import ResearchKit

class SessionController {

    func consentTask() -> ORKOrderedTask {
        
        let document = ORKConsentDocument()
        document.title = "Test Consent"
        
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
        
        let consentSections: [ORKConsentSection] = sectionTypes.map { contentSectionType in
            let consentSection = ORKConsentSection(type: contentSectionType)
            consentSection.summary = "Complete the study"
            consentSection.content = "This survey will ask you three questions and you will also measure your tapping speed by performing a small activity."
            return consentSection
        }
        
        document.sections = consentSections
        document.addSignature(ORKConsentSignature(forPersonWithTitle: nil, dateFormatString: nil, identifier: "signature"))
        
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
    
}
