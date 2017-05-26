//
//  QuestionObject.swift
//  LoveAndHiphop
//
//  Created by hollywoodno on 5/21/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import Parse

enum QuestionType {
  case fact
  case multipleChoice
}

enum LetterGradeScale {
  case A, B, C, D, F
}

class QuestionObject: PFObject, PFSubclassing {
  var id: String?
  var type: QuestionType?
  var question: String?
  var answers: [String]?
  var answer: Int?
  var object: PFObject
  
  init(pfObject: PFObject) {
    id = pfObject.objectId!
    object = pfObject
    question = pfObject["question"] as? String
    answers = pfObject["answers"] as? [String]
    answer = pfObject["answer"] as? Int
    
    let questionType = pfObject["type"] as? String
    
    if questionType == "fact" {
      type = QuestionType.fact
    } else {
      type = QuestionType.multipleChoice
    }
    
    super.init()
  }
  
  // Grades a series of questions based on provided users answers.
  // Based on provided passingGrade, returns a boolean if passingGrade is met.
  
//  class func gradeTest(answeredQuestions: [QuestionObject: Int], passingGrade: LetterGradeScale) -> Bool? {
//    guard !(userAnswers.isEmpty) else {
//      return nil
//    }
//    
//    var grade: Bool!
//    var score: (right: Int, total: Int)?
//    
//    for userAnswer in answeredQuestions {
//      if question.answer == question.userAnswer {
//        score?.right += 1
//      }
//    }
//    
//    return grade
//  }
  
  // Type method to allow converting pfObjects into question objects
  class func loadQuestionObjectsArray(from pfObjects: [PFObject]) -> [QuestionObject] {
    var questionObjects: [QuestionObject] = []
    
    for pfObject in pfObjects {
      let newQuestion = QuestionObject(pfObject: pfObject)
      questionObjects.append(newQuestion)
    }
    
    return questionObjects
  }
  

  
  public class func parseClassName() -> String {
    return "QuestionObject"
  }
}
