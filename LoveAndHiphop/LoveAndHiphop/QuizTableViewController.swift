//
//  QuizTableViewController.swift
//  LoveAndHiphop
//
//  Created by hollywoodno on 4/26/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit

class QuizTableViewController: UITableViewController {
  
  // MARK: PROPERTIES
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var answer1Button: UIButton!
  @IBOutlet weak var answer2Button: UIButton!
  @IBOutlet weak var answer3Button: UIButton!
  @IBOutlet weak var answer4Button: UIButton!
  
  var answerButtons: [UIButton] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set up the question coming from the server
    answerButtons = [answer1Button, answer2Button, answer3Button, answer4Button]
    
  }
  
  // MARK: Update Selected Answer
  @IBAction func onSelectAnswer(_ sender: UIButton) {
    // Update user selected answer
    for button in answerButtons {
      button.isSelected = (button.titleLabel == sender.titleLabel)
      if button.titleLabel == sender.titleLabel {
        button.backgroundColor = UIColor.white
      } else {
        button.backgroundColor = UIColor.gray
        button.alpha = 0.7
      }
    }
    print("Selected: \(sender.currentTitle)")
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
