//
//  Survey.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/2/2.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit
import ResearchKit

class Survey {

    func task() -> ORKNavigableOrderedTask {
        
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
    
}
