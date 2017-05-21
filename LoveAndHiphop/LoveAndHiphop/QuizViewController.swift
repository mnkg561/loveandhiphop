//
//  QuizViewController.swift
//  LoveAndHiphop
//
//  Created by hollywoodno on 5/19/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController, MultipleChoiceQuestionViewDelegate {
  
  // MARK: Properties
  @IBOutlet weak var questionView: UIView!
  
  
  // MARK: Methods
  override func viewDidLoad() {
        super.viewDidLoad()

    // Load questions and position them inside question container
    let questionSubView = MultipleChoiceQuestionView(frame: CGRect(x: 0, y: 0, width: questionView.frame.width, height: questionView.frame.height))
    questionSubView.delegate = self

    questionSubView.question = "Will it be cloudy with a chance of meatballs?"
    questionSubView.answers = ["a", "b", "c", "d"]
    questionView.addSubview(questionSubView)
    questionView.layer.cornerRadius = 5

    
    }

  // MARK: Delegates
  func MultiplChoiceViewDidSelectAnswer(multipleChoiceQuestionView: MultipleChoiceQuestionView, button: UIButton, selectedAnswer: Int) {
    print("In view controller, I know a user has selected answer.")
    print("Here is the view, view: \(multipleChoiceQuestionView)")
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
