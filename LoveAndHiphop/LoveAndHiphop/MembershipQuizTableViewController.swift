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
          let question = quiz["question"] as! Array<Any>
          let questionType = quiz["type"] as! String
          
          if questionType == "fact" {
            self.trueFalseControl.selectedSegmentIndex = -1
            self.question1Label.text = question[0] as? String
            self.trueFalseControl.setTitle("True", forSegmentAt: 0)
            self.trueFalseControl.setTitle("False", forSegmentAt: 1)
            self.factRightAnswer = question[1] as? String
          }
          
          if questionType == "multiple" {
            self.multipleChoiceControl.selectedSegmentIndex = -1
            let answer1 = question[1] as? String
            let answer2 = question[2] as? String
            let answer3 = question[3] as? String
            let answer4 = question[4] as? String
            self.multipleChoiceRightAnswer = question[5] as? String
            self.question2Label.text = question[0] as? String
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
    if userFactAnswer == factRightAnswer || userMultipleChoiceAnswer == multipleChoiceRightAnswer {
      print("YOU PASSED HORRAY!!!!!!!!!!!!!!")
      
      // Modal Showing they passed and login to facebook button
      let resultsVC = storyboard?.instantiateViewController(withIdentifier: "QuizResultsViewController") as! QuizResultsViewController
      let passQuizView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
      passQuizView.backgroundColor = UIColor.orange
      resultsVC.view = passQuizView
//      resultsVC.contentView = passQuizView
      show(resultsVC, sender: self)
//      let fbVC = FBViewController(nibName: "FBViewController", bundle: nil)
//      show(fbVC, sender: self)
    } else {
      print("Oh fudge! No worries you can take the quiz as many times as you like.")
      
      // Same Modal showing failed and cancel button to go back
      loadQuiz()
    }
    
  }
  
  /*
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
   
   // Configure the cell...
   
   return cell
   }
   */
  
  /*
   // Override to support conditional editing of the table view.
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the specified item to be editable.
   return true
   }
   */
  
  /*
   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
   if editingStyle == .delete {
   // Delete the row from the data source
   tableView.deleteRows(at: [indexPath], with: .fade)
   } else if editingStyle == .insert {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }
   }
   */
  
  /*
   // Override to support rearranging the table view.
   override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
   
   }
   */
  
  /*
   // Override to support conditional rearranging of the table view.
   override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
