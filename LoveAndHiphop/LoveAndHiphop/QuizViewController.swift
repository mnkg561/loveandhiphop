//
//  QuizViewController.swift
//  LoveAndHiphop
//
//  Created by hollywoodno on 5/19/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

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
  var quiz: [String: (question: String, answer: Int, selectedAnswer: Int?)] = [:]
  var currentPage: Int = 0
  
  // MARK: Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // When screen rotates scrollView must be updated.
    NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    
    MBProgressHUD.showAdded(to: view, animated: true)
    
    getQuestions()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  // Get initial questions from database, store them and issue first challenge.
  func getQuestions() {
    let query = PFQuery(className: "MembershipQuestion")
    query.findObjectsInBackground { (pfObjects: [PFObject]?, error: Error?) in
      
      MBProgressHUD.hide(for: self.view, animated: true)
      
      if error != nil {
        print("Error retrieving question object, error: \(error?.localizedDescription)")
      }
      
      if pfObjects != nil {
        let questionObjects = QuestionObject.loadQuestionObjectsArray(from: pfObjects!)
        self.questions = questionObjects
        self.loadQuiz()
      }
    }
  }
  
  // Issues a challenge by loading individual questions as subviews of a scrollview.
  func loadQuiz() {
    // Remove any previous questions and set up scrollView
    removeQuestionSubviews()
    
    scrollView.delegate = self
    scrollView.frame = CGRect(x: 0, y: 0, width: questionView.frame.width, height: questionView.frame.height)
    scrollView.contentOffset = .zero
    
    self.currentPage = 0
    currentPageLabel.text = String(describing: 1 + currentPage) // Page numbers on views

    // Set up new questions
    let quizQuestions = selectRandomQuestions(questionObjects: questions, count: 2)
    if quizQuestions != nil {
      loadQuestionSubViews(from: quizQuestions!)
      self.scrollView.contentSize = CGSize(width: self.scrollView.bounds.size.width * CGFloat(self.questionViews.count), height: self.scrollView.bounds.size.height)
      self.numberOfPagesLabel.text = String(describing: self.questionViews.count)
    }
  }
  
  // Returns a random subset of questions from a list of questions.
  func selectRandomQuestions(questionObjects: [QuestionObject], count: Int) -> [QuestionObject]? {
    guard questionObjects.count >= count else {
      return nil
    }
    
    var questions: [QuestionObject] = []
    var randomNumbers: [Int: Bool] = [:]
    while randomNumbers.count < count {
      let randomNumber = Int(arc4random_uniform(UInt32(questionObjects.count)))
      randomNumbers[randomNumber] = true
    }
    
    for i in randomNumbers.keys {
      questions.append(questionObjects[i])
    }
    
    return questions
  }
  
  // Given a list of questions as objects, based on the type of question
  // adds a custom subview to a scrollview.
  func loadQuestionSubViews(from questionObjects: [QuestionObject]) {
    for (i, questionObject) in questionObjects.enumerated() {
      // Add question to quiz
      quiz[questionObject.id!] = (questionObject.question!, questionObject.answer!, nil)
      
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
        
        questionSubView.questionId = questionObject.id!
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
        
        questionSubView.questionId = questionObject.id!
        questionSubView.question = question
        questionSubView.answer = answer
        questionSubView.answers = answers
        
        questionSubView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin, .flexibleLeftMargin]
        
        questionSubView.translatesAutoresizingMaskIntoConstraints = true
        
        self.scrollView.addSubview(questionSubView)
      }
    }
  }
  
  // Removes all subviews from a scrollview.
  func removeQuestionSubviews() {
    for subView in scrollView.subviews {
      subView.removeFromSuperview()
    }
    
    questionViews = []
  }
  
  // Updates scrollView on screen rotation
  func rotated() {
    scrollView.frame = CGRect(x: 0, y: 0, width: questionView.frame.width, height: questionView.frame.height)
    self.scrollView.contentSize = CGSize(width: self.scrollView.bounds.size.width * CGFloat(self.questions.count), height: self.scrollView.bounds.size.height)
    let xOffset = scrollView.bounds.width * CGFloat(currentPage)
    scrollView.setContentOffset(CGPoint(x: xOffset, y:0) , animated: true)
  }
  
  @IBAction func onCancel(_ sender: UIButton) {
    // Return back to landing page (intro view controller)
    let introVC = storyboard?.instantiateViewController(withIdentifier: "IntroViewController") as! IntroViewController
    show(introVC, sender: self)
  }
  
  @IBAction func onSubmit(_ sender: UIButton) {
    // Grade the challenge.
    let pass = gradeQuiz()
    
    let quizResultsVC = storyboard?.instantiateViewController(withIdentifier: "QuizResultsViewController") as! QuizResultsViewController
    quizResultsVC.pass = pass

    present(quizResultsVC, animated: true) {
      // If returning, user failed quiz.
      // Set up another challenge.
      self.loadQuiz()
    }
  }
  
  // Returns a grade for an issued challenge.
  func gradeQuiz() -> Bool {
    var score = 0
    var questionNumber = 0 // Track which questions wrong/right
    
    for question in quiz.values {
      questionNumber += 1
      
      guard let selectedAnswer = question.selectedAnswer else {
        continue
      }
      
      if question.answer == selectedAnswer {
        score += 1
      }
    }
    return Double(Double(score) / Double(questionViews.count)) >= 0.50 // 50% or more is passing
  }
  
  // MARK: Delegates
  func MultiplChoiceViewDidSelectAnswer(multipleChoiceQuestionView: MultipleChoiceQuestionView, button: UIButton, selectedAnswer: Int) {
    print("In view controller, I know a user has selected answer.")
    print("Here is the view, view: \(multipleChoiceQuestionView)")
    print("Here is the button, \(button)")
    print("Here is the answer \(selectedAnswer)")
    
    // Update quiz
    quiz[multipleChoiceQuestionView.questionId!] = (question: multipleChoiceQuestionView.question!, answer: multipleChoiceQuestionView.answer!, selectedAnswer: selectedAnswer)
  }
  
  func FactViewDidSelectAnswer(factQuestionView: FactQuestionView, button: UIButton, selectedAnswer: Int) {
    print("In view controller, I know a user has selected answer.")
    print("Here is the view, view: \(factQuestionView)")
    print("Here is the button, \(button)")
    print("Here is the answer \(selectedAnswer)")
    
    // Update quiz
    quiz[factQuestionView.questionId!] = (question: factQuestionView.question!, answer: factQuestionView.answer!, selectedAnswer: selectedAnswer)
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    // Get the current page based on the scroll offset
    // Pages start at 1 not 0, so current page always incremented by 1
    
    currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
    currentPageLabel.text = String(describing: 1 + currentPage)
    
    // Display submit button when on last question of test.
    submitButton.isHidden = (currentPage + 1 != questionViews.count)
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
  // MARK: Todo
  // Make base class for question uiviews.
}
