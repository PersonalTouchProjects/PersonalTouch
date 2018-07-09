//
//  SurveyTask.swift
//  MyTouch
//
//  Created by Peng Yi Hao on 2018/7/9.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import ResearchKit

public var SurveyTask: ORKOrderedTask {
    
    var steps = [ORKStep]()
    
    
    // We create the ORKInstructionStep object which will let the participant know about the purpose of the survey
    let instructionStep = ORKInstructionStep(identifier: "IntroStep")
    instructionStep.title = "Test Survey"
    instructionStep.text = "Answer five questions to complete the survey."
    steps += [instructionStep]

    // Next, we will add a question with text answer as an input type:
    // Text Input Question
    // The ORKQuestionStep object is used to present a single question to the user. Here we simply ask the user’s name, and we expect a text response from the user.
    // So we create the ORKTextAnswerFormat object to associate with the question.
    let nameAnswerFormat = ORKTextAnswerFormat(maximumLength: 20)
    nameAnswerFormat.multipleLines = false
    let nameQuestionStepTitle = "What is your name?"
    let nameQuestionStep = ORKQuestionStep(identifier: "NameStep", title: nameQuestionStepTitle, answer: nameAnswerFormat)
    steps += [nameQuestionStep]

    
// ORKImageChoice is used to display the images to the user. Typically, image choices are displayed in a horizontal row.

//    let moodQuestion = "How do you feel today?"
//    let moodImages = [
//        (UIImage(named: "Happy")!, "Happy"),
//        (UIImage(named: "Angry")!, "Angry"),
//        (UIImage(named: "Sad")!, "Sad"),
//        ]
//    let moodChoice : [ORKImageChoice] = moodImages.map {
//        return ORKImageChoice(normalImage: $0.0, selectedImage: nil, text: $0.1, value: $0.1 as NSCoding & NSCopying & NSObjectProtocol)
//    }
//    let answerFormat: ORKImageChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: moodChoice)
//    let moodQuestionStep = ORKQuestionStep(identifier: "MoodStep", title: moodQuestion, answer: answerFormat)
//    steps += [moodQuestionStep]


    
// We ask the user to enter his/her age. We define the answer format as numeric using ORKNumericAnswerFormat. At the same time, we also set the minimum and maximum age values.
    
    //Numeric Input Question
    let ageQuestion = "How old are you?"
    let ageAnswer = ORKNumericAnswerFormat.integerAnswerFormat(withUnit: "years")
    ageAnswer.minimum = 8
    ageAnswer.maximum = 85
    let ageQuestionStep = ORKQuestionStep(identifier: "AgeStep", title: ageQuestion, answer: ageAnswer)
    steps += [ageQuestionStep]

    
    //Summary
    let completionStep = ORKCompletionStep(identifier: "SummaryStep")
    completionStep.title = "Thank You!!"
    completionStep.text = "You have completed the survey"
    steps += [completionStep]
    
    
    
    return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
}

