//
//  QuizViewController.swift
//  LoveAndHiphop
//
//  Created by hollywoodno on 5/19/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
  
  // MARK: Properties
  @IBOutlet weak var questionView: UIView!
  
  
  // MARK: Methods
  override func viewDidLoad() {
        super.viewDidLoad()

    // Load questions and position them inside question container
    let questionSubView = MultipleChoiceQuestionView(frame: CGRect(x: 0, y: 0, width: questionView.frame.width, height: questionView.frame.height))

//    questionSubView.question = "fuck"
//    questionSubView.answer1 = "dude"
//    questionSubView.answer2 = "nicki"
//    questionSubView.answer3 = "hello"
//    questionSubView.answer4 = "there"
    questionSubView.answers = ["a", "b", "c", "d"]
    questionView.addSubview(questionSubView)

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
