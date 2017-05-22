//
//  QuizViewController.swift
//  LoveAndHiphop
//
//  Created by hollywoodno on 5/19/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import Parse

class QuizViewController: UIViewController, MultipleChoiceQuestionViewDelegate, FactQuestionViewDelegate {
  
  // MARK: Properties
  @IBOutlet weak var questionView: UIView!
  
  
  // MARK: Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let query = PFQuery(className: "MembershipQuestion")
    query.limit = 1
    query.findObjectsInBackground { (questionObjects: [PFObject]?, error: Error?) in
      if error != nil {
        print("Error retrieving question object, error: \(error?.localizedDescription)")
      }
      
      if questionObjects != nil {
        // Load questions and position them inside question container
        for questionObject in questionObjects! {
          print("Object: \(questionObject)")
          let newQuestion = QuestionObject(pfObject: questionObject)
          self.loadQuestionView(for: newQuestion)
        }
      }
    }
  }
  
  // Load question views into question container
  func loadQuestionView(for questionObject: QuestionObject!) {
    switch questionObject.type! {
    case .fact:
      let questionSubView = FactQuestionView(frame: CGRect(x: 0, y: 0, width: self.questionView.frame.width, height: self.questionView.frame.height))
      questionSubView.delegate = self
      

      questionSubView.question = questionObject.question!
      questionSubView.answer = questionObject.answer!
      questionSubView.answers = questionObject.answers!
      
      self.questionView.addSubview(questionSubView)
      self.questionView.layer.cornerRadius = 5
    case .multipleChoice:
      let questionSubView = MultipleChoiceQuestionView(frame: CGRect(x: 0, y: 0, width: self.questionView.frame.width, height: self.questionView.frame.height))
      
      questionSubView.delegate = self
      
      let question = questionObject.question!
      let answers = questionObject.answers!
      let answer = questionObject.answer!
      
      questionSubView.question = question
      questionSubView.answer = answer
      questionSubView.answers = [answers[0], answers[1], answers[2], answers[3]]
      
      self.questionView.addSubview(questionSubView)
      self.questionView.layer.cornerRadius = 5
    }
  }
  
  // MARK: Delegates
  func MultiplChoiceViewDidSelectAnswer(multipleChoiceQuestionView: MultipleChoiceQuestionView, button: UIButton, selectedAnswer: Int) {
    print("In view controller, I know a user has selected answer.")
    print("Here is the view, view: \(multipleChoiceQuestionView)")
    print("Here is the button, \(button)")
    print("Here is the answer \(selectedAnswer)")
  }
  
  func FactViewDidSelectAnswer(factQuestionView: FactQuestionView, button: UIButton, selectedAnswer: Int) {
    print("In view controller, I know a user has selected answer.")
    print("Here is the view, view: \(factQuestionView)")
    print("Here is the button, \(button)")
    print("Here is the answer \(selectedAnswer)")
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
