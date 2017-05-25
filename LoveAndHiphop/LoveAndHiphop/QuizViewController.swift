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
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var questionView: UIView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var statusView: UIView!
  @IBOutlet weak var progressView: UIProgressView!
  @IBOutlet weak var submitButton: UIButton!
  @IBOutlet weak var currentPageLabel: UILabel!
  @IBOutlet weak var numberOfPagesLabel: UILabel!
  
  var questions: [QuestionObject] = []
  var questionViews: [UIView] = []
  var currentPage: Int = 0
  
  // MARK: Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    scrollView.delegate = self
    scrollView.frame = CGRect(x: 0, y: 0, width: questionView.frame.width, height: questionView.frame.height)
    currentPageLabel.text = String(describing: 1 + currentPage)
    
    // When screen rotates scrollView must be updated.
    NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    
    // Load Quiz
    let query = PFQuery(className: "MembershipQuestion")
    //    query.limit = 2
    query.findObjectsInBackground { (pfObjects: [PFObject]?, error: Error?) in
      if error != nil {
        print("Error retrieving question object, error: \(error?.localizedDescription)")
      }
      
      if pfObjects != nil {
        let questionObjects = QuestionObject.loadQuestionObjectsArray(from: pfObjects!)
        self.questions = questionObjects
        
        self.loadQuestionSubViews(from: questionObjects)
        // This is reset on device rotation which allows scrollView to update with addition/subtraction of screen space
        self.scrollView.contentSize = CGSize(width: self.scrollView.bounds.size.width * CGFloat(self.questionViews.count), height: self.scrollView.bounds.size.height)
        self.numberOfPagesLabel.text = String(describing: self.questionViews.count)
      }
    }
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  func loadQuestionSubViews(from questionObjects: [QuestionObject]) {
    // Generate question subviews for scrollView from question objects.
    
    for (i, questionObject) in questionObjects.enumerated() {
      // The subViews frame will be offset depending on when it is
      // added as a subView.
      let frame = CGRect(x: CGFloat(i) * self.scrollView.bounds.width, y: 0, width: self.scrollView.bounds.width, height: self.scrollView.bounds.height)
      
      // TODO: All questions should subclass a base question class.
      // Will reduce repeated code here.
      switch questionObject.type! {
        
      case .fact:
        let questionSubView = FactQuestionView(frame: frame)
        questionSubView.delegate = self
        
        self.questionViews.append(questionSubView as UIView)
        
        questionSubView.question = questionObject.question!
        questionSubView.answer = questionObject.answer!
        questionSubView.answers = questionObject.answers!
        
        questionSubView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin, .flexibleLeftMargin]
        questionSubView.translatesAutoresizingMaskIntoConstraints = true
        
        self.scrollView.addSubview(questionSubView)
        
      case .multipleChoice:
        let questionSubView = MultipleChoiceQuestionView(frame: frame)
        questionSubView.translatesAutoresizingMaskIntoConstraints = true
        questionSubView.delegate = self
        
        self.questionViews.append(questionSubView as UIView)
        
        let question = questionObject.question!
        let answers = questionObject.answers!
        let answer = questionObject.answer!
        
        questionSubView.question = question
        questionSubView.answer = answer
        questionSubView.answers = answers
        
        questionSubView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin, .flexibleLeftMargin]
        
        questionSubView.translatesAutoresizingMaskIntoConstraints = true
        
        self.scrollView.addSubview(questionSubView)
      }
    }
  }
  
  func rotated() {
    // Updates scrollView on screen rotation
    
    scrollView.frame = CGRect(x: 0, y: 0, width: questionView.frame.width, height: questionView.frame.height)
    self.scrollView.contentSize = CGSize(width: self.scrollView.bounds.size.width * CGFloat(self.questions.count), height: self.scrollView.bounds.size.height)
    let xOffset = scrollView.bounds.width * CGFloat(currentPage)
    scrollView.setContentOffset(CGPoint(x: xOffset, y:0) , animated: true)
  }
  
  // MARK: Delegates
  func MultiplChoiceViewDidSelectAnswer(multipleChoiceQuestionView: MultipleChoiceQuestionView, button: UIButton, selectedAnswer: Int) {
    print("In view controller, I know a user has selected answer.")
    print("Here is the view, view: \(multipleChoiceQuestionView)")
    print("Here is the button, \(button)")
    print("Here is the answer \(selectedAnswer)")
  }
  
  @IBAction func onCancel(_ sender: UIButton) {
    // Return back to landing page (intro view controller)
    let introVC = storyboard?.instantiateViewController(withIdentifier: "IntroViewController") as! IntroViewController
    show(introVC, sender: self)
  }
  
  func FactViewDidSelectAnswer(factQuestionView: FactQuestionView, button: UIButton, selectedAnswer: Int) {
    print("In view controller, I know a user has selected answer.")
    print("Here is the view, view: \(factQuestionView)")
    print("Here is the button, \(button)")
    print("Here is the answer \(selectedAnswer)")
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    // Get the current page based on the scroll offset

    currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
    
    currentPageLabel.text = String(describing: 1 + currentPage)
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
