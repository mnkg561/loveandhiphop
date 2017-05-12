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
  @IBOutlet weak var downArrowImageView: UIImageView!
  @IBOutlet weak var loginButton: UIButton!
  var resultsView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loginButton.layer.cornerRadius = 4
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onDownArrowTap(_ sender: UITapGestureRecognizer) {
    let fbVC = FBViewController(nibName: "FBViewController", bundle: nil)
    show(fbVC, sender: nil)
  }
  
  @IBAction func onClose(_ sender: Any) {
    dismiss(animated: true, completion: nil)
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
