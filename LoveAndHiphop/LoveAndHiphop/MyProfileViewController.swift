//
//  MyProfileViewController.swift
//  LoveAndHiphop
//
//  Created by hollywoodno on 6/16/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController, MeOptionsViewControllerDelegate {
  
  // MARK: Properties
  @IBOutlet weak var containerView: UIView!
  
  // Manages selection of Profile Menu Options
  private lazy var meOptionsViewController: MeOptionsViewController = {
    
    let storyboard = UIStoryboard(name: "User", bundle: Bundle.main)
    var viewController = storyboard.instantiateViewController(withIdentifier: "MeOptionsViewController") as! MeOptionsViewController
    
    return viewController
  }()
  
  // Default selected menu option for profile view/container view
  private lazy var userProfileViewController: UserProfileViewController = {
    let storyboard = UIStoryboard(name: "User", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
    
    return viewController
  }()
  
  private var activeViewController: UIViewController? {
    // Updates container view to display profile menu option/s
    didSet {
      removeInactiveViewController(inactiveViewController: oldValue)
      
      // Save previous selected menu option so outward pinch returns to it
      if oldValue != nil {
        if !(oldValue! is MeOptionsViewController) {
          lastActiveViewController = oldValue!
        }
      }
      
      updateActiveViewController()
    }
  }
  
  var lastActiveViewController: UIViewController?
  
  // MARK: Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set initial menu option to users profile view
    activeViewController = userProfileViewController
  }
  
  
  @IBAction func onPinch(_ sender: UIPinchGestureRecognizer) {
    // Pinch inward displays profile menu options, otherwise
    // it displays the last displayed option
    if sender.velocity < 0 {
      meOptionsViewController.delegate = self
      activeViewController = meOptionsViewController
    } else {
      if lastActiveViewController != nil {
        activeViewController = lastActiveViewController!
      }
    }
  }
  
  private func removeInactiveViewController(inactiveViewController: UIViewController?) {
    // Removes previously displayed profile menu option/s from container view
    if isViewLoaded {
      if let inActiveVC = inactiveViewController {
        inActiveVC.willMove(toParentViewController: nil)
        inActiveVC.view.removeFromSuperview()
        inActiveVC.removeFromParentViewController()
      }
    }
  }
  
  private func updateActiveViewController() {
    // Updates container view with profile menu option/s
    if isViewLoaded {
      if let activeVC = activeViewController {
        addChildViewController(activeVC)
        containerView.addSubview(activeVC.view)
        activeVC.view.frame = containerView.bounds
        
        activeVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Pinch gesture allows user to view all profile menu selections,
        // and return to any previous selected menu option
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(onPinch(_:)))
        activeVC.view.addGestureRecognizer(pinch)
        
        activeVC.didMove(toParentViewController: self)
      }
    }
  }
  
  // MARK: Delegates
  func meOptionsViewController(viewController: UIViewController, didSelectMenuOption option: Int?) {
    // Update container view with user's selected profile menu option
    if option != nil {
      activeViewController = viewController
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
