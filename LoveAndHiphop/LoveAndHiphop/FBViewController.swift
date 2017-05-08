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
  
  // MARK: User Facebook Profile Data
  func loadFBData() {
    
    var savedFBProfileData = true
    let requestParameters = ["fields": "id, email, first_name, last_name"]
    
    let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters)
    
    userDetails?.start(completionHandler: { (connection: FBSDKGraphRequestConnection?, data: Any?, error: Error?) in
      if(error != nil) {
        print("\(error?.localizedDescription)")
        savedFBProfileData = false
        return
      }
      
      // FB graph API returned user data
      if data != nil {
        // User Facebook data from graph call
        let userFBData = data as! NSDictionary
        
        let currentUser = PFUser.current()
        if currentUser != nil {
          let query = PFQuery(className:"_User")
          query.getObjectInBackground(withId: (currentUser?.objectId)!) {
            (user: PFObject?, error: Error?) -> Void in
            if error != nil {
            }
            
            if let user = user {
              
              // Save user facebook profile data to parse
              // and update current user
              if let firstName = userFBData["first_name"] as? String {
                currentUser?.setObject(firstName, forKey: "firstName")
                user["firstName"] = firstName
              }
              
              if let lastName = userFBData["last_name"] as? String {
                currentUser?.setObject(lastName, forKey: "lastName")
                user["lastName"] = lastName
              }
              
              if let email = userFBData["email"] as? String {
                currentUser?.setObject(email, forKey: "email")
                user["email"] = email
              }
              
              if let gender = userFBData["gender"] {
                currentUser?.setObject(gender, forKey: "gender")
                user["gender"] = gender
              }
              
              // Retrieve users profile pic from Facebook
              let facebookID = userFBData["id"] as? String
              if facebookID != nil {
                let pictureURL = "https://graph.facebook.com/\(facebookID!)/picture?type=large&return_ssl_resources=1"
                let url = URL(string: pictureURL)
                let request = URLRequest(url: url!)
                let session = URLSession(
                  configuration: URLSessionConfiguration.default,
                  delegate:nil,
                  delegateQueue:OperationQueue.main
                )
                
                let task: URLSessionDataTask = session.dataTask(
                  with: request as URLRequest,
                  completionHandler: { (data, response, error) in
                    if error != nil {
                      print("Error getting profile url from facebook \(error)")
                    }
                    if let data = data {
                      
                      let picture = PFFile(data: data)! as PFFile
                      PFUser.current()?.setObject(picture, forKey: "profilePic")
                      user["profilePic"] = picture
                      
                    }
                    else {
                      print("Error: \(error?.localizedDescription)")
                    }
                    
                });
                task.resume()
              }
              
              user.saveInBackground(block: { (success: Bool, error: Error?) in
                savedFBProfileData = success
                if error != nil {
                  print("Error updating user object, error: \(error)")
                } else {
                  
                  savedFBProfileData = false
                }
              })
            }
          }
        } else {
          
          
        }
      }
    })
  }
  
  @IBAction func onFBLogin(_ sender: Any) {
    PFFacebookUtils.logInInBackground(withReadPermissions: ["public_profile", "email"]) { (user: PFUser?, error: Error?) in
      if let user = user {
        if user.isNew {
          print("User signed up and logged in through Facebook!")
        } else {
          print("User logged in through Facebook!")
        }
        
        // Get user FB basic data
        self.loadFBData()
        
        // Currently, just send all users to profile set up.
        let storyboard = UIStoryboard.init(name: "User", bundle: nil)
        let userSignUpVC = storyboard.instantiateViewController(withIdentifier: "UserSignupTableViewController") as! UserSignupTableViewController
        self.show(userSignUpVC, sender: self)
      } else {
        print("Uh oh. The user cancelled the Facebook login.")
      }
    }
  }
  
  
  // MARK: - Navigation
  
  
  // MARK: TODO
  // Move FB data to FB Client
  // Set up user data model
  
}
