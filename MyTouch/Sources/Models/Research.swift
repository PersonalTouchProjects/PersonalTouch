//
//  Survey.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/21.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import ResearchKit

struct Research {
    
    static var survey: ORKOrderedTask {
        
        var steps = [ORKStep]()
        
        // ID
        let idFormat = ORKNumericAnswerFormat(style: .integer)
        idFormat.minimum = 0000
        idFormat.maximum = 9999
        let idStepTitle = "受測者編號"
        let idStep = ORKQuestionStep(identifier: "myTouch.survey.participantID", title: idStepTitle, answer: idFormat)
        idStep.isOptional = false
        steps += [idStep]
//
//        // name
//        let nameAnswerFormat = ORKTextAnswerFormat(maximumLength: 20)
//        nameAnswerFormat.multipleLines = false
//        let nameQuestionStepTitle = "What is your name?"
//        let nameQuestionStep = ORKQuestionStep(identifier: "myTouch.survey.name", title: nameQuestionStepTitle, answer: nameAnswerFormat)
//        steps += [nameQuestionStep]
//
//
//        // birth year
//        let calendar = Calendar(identifier: .iso8601)
//        let birthdayAnswer = ORKDateAnswerFormat(style: .date, defaultDate: nil, minimumDate: nil, maximumDate: nil, calendar: calendar)
//        let birthdayQuestion = "When is your birthday?"
//        let ageQuestionStep = ORKQuestionStep(identifier: "myTouch.survey.birthYear", title: birthdayQuestion, answer: birthdayAnswer)
//        steps += [ageQuestionStep]
//
//        // gnder
//
//        let genderQuestion = "What is your biological sex?"
//        let choices: [ORKTextChoice] = [
//            ORKTextChoice(text: "Female", detailText: nil, value: ORKBiologicalSexIdentifier.female as NSCoding & NSCopying & NSObjectProtocol, exclusive: true),
//            ORKTextChoice(text: "Male", detailText: nil, value: ORKBiologicalSexIdentifier.male as NSCoding & NSCopying & NSObjectProtocol, exclusive: true),
//            ORKTextChoice(text: "Other", detailText: nil, value: ORKBiologicalSexIdentifier.other as NSCoding & NSCopying & NSObjectProtocol, exclusive: true),
//        ]
//        let genderAnswer = ORKTextChoiceAnswerFormat(style: .singleChoice, textChoices: choices)
//        let genderQuestionStep = ORKQuestionStep(identifier: "myTouch.survey.gender", title: genderQuestion, answer: genderAnswer)
//        steps += [genderQuestionStep]
//
//        let dominantHandQuestion = "Which one is your dominant hand?"
//        let dominantHandChoices: [ORKTextChoice] = [
//            ORKTextChoice(text: "Left Hand", detailText: nil, value: Participant.DominantHand.left.rawValue as NSCoding & NSCopying & NSObjectProtocol, exclusive: true),
//            ORKTextChoice(text: "Right Hand", detailText: nil, value: Participant.DominantHand.right.rawValue as NSCoding & NSCopying & NSObjectProtocol, exclusive: true),
//            ORKTextChoice(text: "Both", detailText: nil, value: Participant.DominantHand.both.rawValue as NSCoding & NSCopying & NSObjectProtocol, exclusive: true),
//            ORKTextChoice(text: "None", detailText: nil, value: Participant.DominantHand.none.rawValue as NSCoding & NSCopying & NSObjectProtocol, exclusive: true),
//        ]
//        let dominantHandAnswer = ORKTextChoiceAnswerFormat(style: .singleChoice, textChoices: dominantHandChoices)
//        let dominantHandQuestionStep = ORKQuestionStep(identifier: "myTouch.survey.dominantHand", title: dominantHandQuestion, answer: dominantHandAnswer)
//        steps += [dominantHandQuestionStep]
//
//        // note
//        let noteAnswerFormat = ORKTextAnswerFormat(maximumLength: 200)
//        noteAnswerFormat.multipleLines = true
//        let noteQuestionStepTitle = "Notes?"
//        let noteQuestionStep = ORKQuestionStep(identifier: "myTouch.survey.note", title: noteQuestionStepTitle, answer: noteAnswerFormat)
//        noteQuestionStep.isOptional = true
//        steps += [noteQuestionStep]
//
//        //Summary
//        let completionStep = ORKCompletionStep(identifier: "myTouch.survey.summaryStep")
//        completionStep.title = "Thank You!!"
//        completionStep.text = "You have completed the survey"
//        steps += [completionStep]
        
        return ORKOrderedTask(identifier: "myTouch.survey", steps: steps)
    }
}
