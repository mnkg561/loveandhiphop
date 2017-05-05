//
//  FBViewController.swift
//  LoveAndHiphop
//
//  Created by hollywoodno on 5/4/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import ParseFacebookUtilsV4

class FBViewController: UIViewController {
  @IBOutlet var contentView: UIView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onFBLogin(_ sender: Any) {
    PFFacebookUtils.logInInBackground(withReadPermissions: ["public_profile", "email"]) { (user: PFUser?, error: Error?) in
      if let user = user {
        if user.isNew {
          print("User signed up and logged in through Facebook!")
        } else {
          print("User logged in through Facebook!")
        }
        
        // Currently, just send logged in user to dating section.
        // Eventually they will be sent to Profile Setup.
        let flirtVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarController")
        
        self.show(flirtVC, sender: self)
      } else {
        print("Uh oh. The user cancelled the Facebook login.")
      }
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
