//
//  MeOptionsViewController.swift
//  LoveAndHiphop
//
//  Created by hollywoodno on 6/14/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit

protocol MeOptionsViewControllerDelegate {
  // Alert delegates that a profile menu option is selected
  func meOptionsViewController(viewController: UIViewController, didSelectMenuOption option: Int?)
}

class MeOptionsViewController: UIViewController {
  
  // MARK: Properties
  @IBOutlet weak var viewProfileButton: UIButton!
  @IBOutlet weak var editProfileButton: UIButton!
  @IBOutlet weak var logoutButton: UIButton!
  
  var viewControllers: [UIViewController] = {
    let storyboard = UIStoryboard.init(name: "User", bundle: nil)
    let viewProfile = storyboard.instantiateViewController(withIdentifier: "UserProfileViewController")
    let editProfile = storyboard.instantiateViewController(withIdentifier: "UserSignupTableViewController")
    
    return [viewProfile, editProfile]
  }()
  
  var delegate: MeOptionsViewControllerDelegate?
  
  // MARK: Methods
  // TODO: Make custom UIButton or work with appearance()
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewProfileButton.layer.cornerRadius = 5
    viewProfileButton.layer.borderWidth = 1
    viewProfileButton.layer.borderColor = UIColor(red: 49/255, green: 136/255, blue: 170/255, alpha: 1.0).cgColor
    
    editProfileButton.layer.cornerRadius = 5
    editProfileButton.layer.borderWidth = 1
    editProfileButton.layer.borderColor = UIColor(red: 49/255, green: 136/255, blue: 170/255, alpha: 1.0).cgColor
    
    logoutButton.layer.cornerRadius = 5
    logoutButton.layer.borderWidth = 1
    logoutButton.layer.borderColor = UIColor(red: 49/255, green: 136/255, blue: 170/255, alpha: 1.0).cgColor
  }
  
  @IBAction func onSelectMeOption(_ sender: UIButton) {
    // Alerts that new profile menu option has been selected.
    delegate?.meOptionsViewController(viewController: viewControllers[sender.tag], didSelectMenuOption: sender.tag)
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
