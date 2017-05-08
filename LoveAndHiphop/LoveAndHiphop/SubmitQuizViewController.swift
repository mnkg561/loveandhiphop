//
//  SubmitQuizViewController.swift
//  LoveAndHiphop
//
//  Created by hollywoodno on 4/27/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit

class SubmitQuizViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onSubmit(_ sender: Any) {
    // Get users answers
    
    // Grade test
    let passed = grade(test: ["answers"])
    
    // Base on grade send to Facebook login or reissue test
    if passed {
      // Send to Facebook login
      print("Nailed it!")
      let fbVC = FBViewController(nibName: "FBViewController", bundle: nil)
      show(fbVC, sender: self)
    } else {
      // Send to beginning of quiz
      print("Oh fudge, you didn't pass this time!")
      
      // Currently, if user fails quiz we just reissue same quiz
      let membershipQuizVC = storyboard?.instantiateViewController(withIdentifier: "MembershipQuizTableViewController") as! MembershipQuizTableViewController
      show(membershipQuizVC, sender: self)
    }
  }
  
  func grade(test: [String]) -> Bool {
    // Compare users test with answers
    
    // Return true if user gets 2/3 right otherwise return false
    return true
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
