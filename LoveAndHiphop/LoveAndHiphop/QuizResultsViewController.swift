//
//  QuizResultsViewController.swift
//  LoveAndHiphop
//
//  Created by hollywoodno on 5/11/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import Parse

class QuizResultsViewController: UIViewController {
  
  // MARK: Properties
  @IBOutlet weak var passView: UIView!
  @IBOutlet weak var failView: UIView!
  @IBOutlet weak var retakeButton: UIButton!
  var pass: Bool?
  
  // MARK: Methods
  override func viewDidLoad() {
    super.viewDidLoad()

    // Flips the next button to be a previous button
    retakeButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    
    // Display correct view, depending on pass/fail challenge.
    if pass! {
      failView.isHidden = true
    } else {
      passView.isHidden = true
    }
  }
  
  @IBAction func onRetake(_ sender: UIButton) {
    // Reissues challenge.
    let quizVC = storyboard?.instantiateViewController(withIdentifier: "QuizViewController") as! QuizViewController
    show(quizVC, sender: self)
  }
  
  @IBAction func onSignIn(_ sender: Any) {
    // User can sign in after passing challenge.
    let fbVC = FBViewController(nibName: "FBViewController", bundle: nil)
    show(fbVC, sender: self)
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
