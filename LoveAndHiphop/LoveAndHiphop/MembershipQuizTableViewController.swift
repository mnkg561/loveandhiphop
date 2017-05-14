//
//  MembershipQuizTableViewController.swift
//  LoveAndHiphop
//
//  Created by hollywoodno on 5/7/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import Parse

class MembershipQuizTableViewController: UITableViewController {
  
  // MARK: Properties
  @IBOutlet weak var question1Label: UILabel!
  @IBOutlet weak var question2Label: UILabel!
  @IBOutlet weak var trueFalseControl: UISegmentedControl!
  @IBOutlet weak var multipleChoiceControl: UISegmentedControl!
  
  var factRightAnswer: String?
  var multipleChoiceRightAnswer: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Load quiz from parse
    loadQuiz()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 5
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    
    if section == 2 || section == 3 {
      return 2
    }
    
    return 1
  }
  
  
  // MARK: Load Quiz
  func loadQuiz() {
    let query = PFQuery(className: "Quiz")
    query.findObjectsInBackground { (quizzes: [PFObject]?, error: Error?) in
      if error != nil {
        print("Error retrieving quizes")
      } else {
        
        for quiz in quizzes! {
          let question = quiz["question"] as! Array<String>
          let questionType = quiz["type"] as! String
          
          if questionType == "fact" {
            self.trueFalseControl.selectedSegmentIndex = -1
            self.question1Label.text = question[0]
            self.trueFalseControl.setTitle("True", forSegmentAt: 0)
            self.trueFalseControl.setTitle("False", forSegmentAt: 1)
            self.factRightAnswer = question[1]
          }
          
          if questionType == "multiple" {
            self.multipleChoiceControl.selectedSegmentIndex = -1
            let answer1 = question[1]
            let answer2 = question[2]
            let answer3 = question[3]
            let answer4 = question[4]
            self.multipleChoiceRightAnswer = question[5]
            self.question2Label.text = question[0]
            self.multipleChoiceControl.setTitle(answer1, forSegmentAt: 0)
            self.multipleChoiceControl.setTitle(answer2, forSegmentAt: 1)
            self.multipleChoiceControl.setTitle(answer3, forSegmentAt: 2)
            self.multipleChoiceControl.setTitle(answer4, forSegmentAt: 3)
          }
        }
      }
    }
  }
  
  @IBAction func onSubmitQuiz(_ sender: Any) {
    
    //Grade users test
    let userFactAnswer = String(describing: trueFalseControl.selectedSegmentIndex)
    let userMultipleChoiceAnswer = String(describing: multipleChoiceControl.selectedSegmentIndex)
    
    // Prepare results view controller custom result views
    let resultsVC = storyboard?.instantiateViewController(withIdentifier: "QuizResultsViewController") as! QuizResultsViewController
   
    let passQuizViewNib = UINib(nibName: "PassQuizView", bundle: nil)
    let passQuizView = passQuizViewNib.instantiate(withOwner: resultsVC, options: nil)[0] as! UIView
    resultsVC.view.addSubview(passQuizView)
    
    let failQuizViewNib = UINib(nibName: "FailQuizView", bundle: nil)
    let failQuizView = failQuizViewNib.instantiate(withOwner: "QuizResultsViewController", options: nil)[0] as! UIView
    resultsVC.view.addSubview(failQuizView)
    
    // Passing grade users sent to login with Facebook, else
    // quiz is reloaded.
    if userFactAnswer == factRightAnswer || userMultipleChoiceAnswer == multipleChoiceRightAnswer {
      resultsVC.view.bringSubview(toFront: passQuizView)
      show(resultsVC, sender: nil)
    } else {
      present(resultsVC, animated: true, completion: {
        self.loadQuiz()
      })
    }
    
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
