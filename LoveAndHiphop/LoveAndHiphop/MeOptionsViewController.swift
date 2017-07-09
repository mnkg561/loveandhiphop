//
//  MeOptionsViewController.swift
//  LoveAndHiphop
//
//  Created by hollywoodno on 6/14/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import Parse

protocol MeOptionsViewControllerDelegate {
  // Alert delegates that a profile menu option is selected
  func meOptionsViewController(viewController: UIViewController, didSelectMenuOption option: Int?)
}

class MeOptionsViewController: UIViewController, UIScrollViewDelegate {
  
  // MARK: Properties
  @IBOutlet weak var viewProfileButton: UIImageView!
  @IBOutlet weak var editProfileButton: UIImageView!
  @IBOutlet weak var logoutButton: UIImageView!
  
  var viewControllers: [UIViewController] = {
    let storyboard = UIStoryboard.init(name: "User", bundle: nil)
    let viewProfile = storyboard.instantiateViewController(withIdentifier: "UserProfileViewController")
    let editProfile = storyboard.instantiateViewController(withIdentifier: "UserSignupTableViewController")
    
    return [viewProfile, editProfile]
  }()
  
  var delegate: MeOptionsViewControllerDelegate?
  
  // MARK: Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let viewProfileTap = UITapGestureRecognizer(target: self, action: #selector(onSelectMeOption(_:)))
    let editProfileTap = UITapGestureRecognizer(target: self, action: #selector(onSelectMeOption(_:)))
    let logoutTap = UITapGestureRecognizer(target: self, action: #selector(onLogout(_:)))
    
    viewProfileButton.addGestureRecognizer(viewProfileTap)
    editProfileButton.addGestureRecognizer(editProfileTap)
    logoutButton.addGestureRecognizer(logoutTap)

  }
  
  func onSelectMeOption(_ sender: UITapGestureRecognizer) {
    // Alerts new profile menu option has been selected.
    let sender = sender.view as! UIImageView
    delegate?.meOptionsViewController(viewController: viewControllers[sender.tag], didSelectMenuOption: sender.tag)
  }
  
  // Delegates
  func onLogout(_ sender: UIButton) {
    PFUser.logOutInBackground { (error: Error?) in
      let storyboard = UIStoryboard(name: "Quiz", bundle: nil)
      let quizVC = storyboard.instantiateViewController(withIdentifier: "IntroViewController")
      self.show(quizVC, sender: nil)
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
