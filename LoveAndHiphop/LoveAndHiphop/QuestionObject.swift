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

class QuestionObject: PFObject, PFSubclassing {
  var type: QuestionType?
  var question: String?
  var answers: [String]?
  var answer: Int?
  var object: PFObject
  
  init(pfObject: PFObject) {
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
  
  public class func parseClassName() -> String {
    return "QuestionObject"
  }
}
