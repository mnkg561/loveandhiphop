//
//  QuizViewController.swift
//  LoveAndHiphop
//
//  Created by hollywoodno on 5/19/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import Parse

class QuizViewController: UIViewController, MultipleChoiceQuestionViewDelegate, FactQuestionViewDelegate, UIScrollViewDelegate {
  
  // MARK: Properties
  @IBOutlet weak var questionView: UIView!
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var scrollView: UIScrollView!
  
  var questions: [QuestionObject] = []
  var questionViews: [UIView] = []
  // MARK: Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    scrollView.delegate = self
    scrollView.frame = questionView.bounds
//    questionView.layer.cornerRadius = 5
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    
    let query = PFQuery(className: "MembershipQuestion")
    query.limit = 2
    query.findObjectsInBackground { (pfObjects: [PFObject]?, error: Error?) in
      if error != nil {
        print("Error retrieving question object, error: \(error?.localizedDescription)")
      }
      
      if pfObjects != nil {
        let questionObjects = QuestionObject.loadQuestionObjectsArray(from: pfObjects!)
        self.questions = questionObjects
        
        self.loadQuestionSubViews(from: questionObjects)
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.bounds.size.width * CGFloat(self.questions.count), height: self.scrollView.bounds.size.height)
      }
      
    }
  }
  
  func loadQuestionSubViews(from questionObjects: [QuestionObject]) {
    for questionObject in questionObjects {
      switch questionObject.type! {
        
      case .fact:
        let questionSubView = FactQuestionView(frame: CGRect(x: 0, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height))
        questionSubView.delegate = self
        self.questionViews.append(questionSubView as UIView)
        
        
        questionSubView.question = questionObject.question!
        questionSubView.answer = questionObject.answer!
        questionSubView.answers = questionObject.answers!
        
        self.scrollView.addSubview(questionSubView)
        
      case .multipleChoice:
        let questionSubView = MultipleChoiceQuestionView(frame: CGRect(x:0, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height))
        questionSubView.delegate = self
        self.questionViews.append(questionSubView as UIView)
        
        let question = questionObject.question!
        let answers = questionObject.answers!
        let answer = questionObject.answer!
        
        questionSubView.question = question
        questionSubView.answer = answer
        questionSubView.answers = answers
        
        self.scrollView.addSubview(questionSubView)
      }
    }
  }
  //  // Load question views into question container
  //  func loadQuestionView(number i: Int, with questionObject: QuestionObject!) {
  //    switch questionObject.type! {
  //    case .fact:
  //      let questionSubView = FactQuestionView(frame: CGRect(x: CGFloat(i) * scrollView.frame.width, y: 0, width: self.questionView.frame.width, height: self.questionView.frame.height))
  //      questionSubView.delegate = self
  //
  //
  //      questionSubView.question = questionObject.question!
  //      questionSubView.answer = questionObject.answer!
  //      questionSubView.answers = questionObject.answers!
  //
  //      self.scrollView.addSubview(questionSubView)
  //      self.questionView.layer.cornerRadius = 5
  //    case .multipleChoice:
  //      let questionSubView = MultipleChoiceQuestionView(frame: CGRect(x: CGFloat(i) * scrollView.frame.width, y: 0, width: self.questionView.frame.width, height: self.questionView.frame.height))
  //
  //      questionSubView.delegate = self
  //
  //      let question = questionObject.question!
  //      let answers = questionObject.answers!
  //      let answer = questionObject.answer!
  //
  //      questionSubView.question = question
  //      questionSubView.answer = answer
  //      questionSubView.answers = answers
  //
  //      self.scrollView.addSubview(questionSubView)
  //      self.questionView.layer.cornerRadius = 5
  //    }
  //  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  func rotated() {
    self.scrollView.contentSize = CGSize(width: self.scrollView.bounds.size.width * CGFloat(self.questions.count), height: self.scrollView.bounds.size.height)
    //    if UIDevice.current.orientation.isLandscape {
    //      print("Landscape")
    //      self.scrollView.frame = questionView.bounds
    //      self.scrollView.contentSize = CGSize(width: self.scrollView.bounds.size.width * CGFloat(questions.count), height: self.scrollView.bounds.size.height)
    //
    //      self.scrollView.translatesAutoresizingMaskIntoConstraints = true
    //      self.scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    //    } else {
    //      print("Portrait")
    //      self.scrollView.contentSize = CGSize(width: self.scrollView.bounds.size.width * CGFloat(questions.count), height: self.scrollView.bounds.size.height)
    //
    //      self.scrollView.translatesAutoresizingMaskIntoConstraints = true
    //      self.scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    //    }
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
  
  //  func scrollViewDidScroll(_ scrollView: UIScrollView) {
  //    questionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  //    questionView.bringSubview(toFront: scrollView.subviews[1])
  //  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
