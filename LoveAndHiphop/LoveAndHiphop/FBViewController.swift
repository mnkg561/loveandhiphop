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
  @IBOutlet weak var loginFBButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loginFBButton.layer.cornerRadius = 4
  }
  
  // MARK: User Facebook Profile Data
  func loadFBData() {
    
    let requestParameters = ["fields": "id, email, first_name, last_name, gender"]
    
    let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters)
    
    userDetails?.start(completionHandler: { (connection: FBSDKGraphRequestConnection?, data: Any?, error: Error?) in
      
      if(error != nil) {
        print("############ error loading facebook data")
        print("\(error?.localizedDescription)")
        return
      }
      
      // FB graph API returned user data
      if data != nil {
        print("########## GOT SOME FACEBOOK DATA")
        // User Facebook data from graph call
        let userFBData = data as! NSDictionary
        
        if let currentUser = PFUser.current() {
          // Save user facebook profile data to parse
          // and update current user
          if let firstName = userFBData["first_name"] as? String {
            currentUser.setObject(firstName, forKey: "firstName")
          }
          
          if let lastName = userFBData["last_name"] as? String {
            currentUser.setObject(lastName, forKey: "lastName")
          }
          
          if let email = userFBData["email"] as? String {
            currentUser.setObject(email, forKey: "email")
          }
          
          if let gender = userFBData["gender"] {
            currentUser.setObject(gender, forKey: "gender")
          }
          
          currentUser.saveInBackground()
          
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
                  print("########## Error getting profile url from facebook \(error)")
                }
                if data != nil {
                  let data = data!
                  print("############ GOT THE PROFILE PIC!!!!!")
                  let extensionString: String = ".jpg"
                  let imageFile = PFFile(name:"profileImage" + extensionString, data:data)
                  let image = imageFile!
                  PFUser.current()?.setObject(image, forKey: "profilePicImage")
                  currentUser.saveInBackground()
                }
                else {
                  print("############ Error: \(error?.localizedDescription)")
                }
            });
            task.resume()
          }
          
          currentUser.saveInBackground(block: { (success: Bool, error: Error?) in
            if error != nil {
              print("Error updating user object, error: \(error)")
            }
            if success {
              print("Successfully updated user profile with Facebook data.")
            }
          })
        }
      }
    })
  }
  
  @IBAction func onFBLogin(_ sender: Any) {
    PFFacebookUtils.logInInBackground(withReadPermissions: ["public_profile", "email"]) { (user: PFUser?, error: Error?) in
      if let user = user {
        print("User logged in through Facebook!")
        self.loadFBData()
        
        // check if user is new
        if user.isNew {
          user["isProfileComplete"] = false
          print("#####$$$$$$$$$$$$$$ NEW USER, \(user.isNew)")
          PFUser.current()?["isProfileComplete"] = false
          user.saveInBackground()
        }
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let matchesVC = storyboard.instantiateViewController(withIdentifier: "HomeTabBarController")
        // After update user can't go back to profile set up section
        matchesVC.navigationItem.hidesBackButton = true
        matchesVC.childViewControllers[0].navigationItem.hidesBackButton = true
        self.show(matchesVC, sender: self)
      } else {
        print("Uh oh. The user cancelled the Facebook login.")
      }
    }
  }
  
  
  // MARK: - Navigation
  
  
  // MARK: TODO
  // Move FB data to FB Client
  // Set up user data model
  
  // Add this to the header of your file, e.g. in ViewController.m
  // after #import "ViewController.h"
//  #import <FBSDKCoreKit/FBSDKCoreKit.h>
//  #import <FBSDKLoginKit/FBSDKLoginKit.h>
//  
//  // Add this to the body
//  @implementation ViewController
//  
//  - (void)viewDidLoad {
//  [super viewDidLoad];
//  FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
//  // Optional: Place the button in the center of your view.
//  loginButton.center = self.view.center;
//  [self.view addSubview:loginButton];
//  }
//  
//  @end
  
}
