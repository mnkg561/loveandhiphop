//
//  UserSignupTableViewController.swift
//  LoveAndHiphop
//
//  Created by Mogulla, Naveen on 5/7/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4

class UserSignupTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @IBOutlet weak var userInterestedInLabel: UISegmentedControl!
  @IBOutlet weak var userProfilePicImageView: UIImageView!
  @IBOutlet weak var userIntroTextView: UITextView!
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var userAgeTextField: UITextField!
  @IBOutlet weak var userHeightTextField: UITextField!
  @IBOutlet weak var userProfessionTextField: UITextField!
  @IBOutlet weak var userCountryTextField: UITextField!
  @IBOutlet weak var userStateTextField: UITextField!
  @IBOutlet weak var userCityTextField: UITextField!
  @IBOutlet weak var userHipHopIdentity: UISegmentedControl!
  @IBOutlet weak var userOtherInterestsTextView: UITextView!
  @IBOutlet weak var userPreferenceMinAgeTextField: UITextField!
  @IBOutlet weak var userPreferenceMaxAgeTextField: UITextField!
  @IBOutlet weak var userPreferenceMinHeight: UITextField!
  @IBOutlet weak var userPreferenceMaxHeight: UITextField!
  @IBOutlet weak var emailIdTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem
    
    userProfilePicImageView.isUserInteractionEnabled = true
  }
  
  
  // MARK: ViewDidAppear: Prepopulate User Data from Parse
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    
    // Prepopulate profile fields with stored user data
    PFUser.current()?.fetchInBackground(block: { (user: PFObject?, error: Error?) in
      if error == nil {
        if let user = user {
          if let firstName = user["firstName"] as? String {
            self.firstNameTextField.text = firstName
          }
          if let lastName = user["lastName"] as? String {
            self.lastNameTextField.text = lastName
          }
          if let email = user["email"] as? String {
            self.emailIdTextField.text = email
          }
          if let gender = user["gender"] as? String {
            // Update UI to include gender
          }
          
          // Load profile image
          if let profilePic = user["profilePic"] as? PFFile {
            profilePic.getDataInBackground(block: { (data: Data?, error: Error?) in
              if (error == nil) {
                self.userProfilePicImageView.image = UIImage(data: data!)
              }
            })
          }
        }
      }
    })
  }
  
  // MARK: Update User Profile Data in Parse
  @IBAction func onUpdateProfile(_ sender: Any) {
    // Update user profile data
    if PFUser.current() != nil {
      let currentUser = PFUser.current()
      let query = PFQuery(className:"_User")
      
      query.getObjectInBackground(withId: (currentUser?.objectId)!, block: { (userProfile: PFObject?, error: Error?) in
        userProfile?["firstName"] = self.firstNameTextField.text
        userProfile?["lastName"] = self.lastNameTextField.text
        userProfile?["userIntro"] = self.userIntroTextView.text
        userProfile?["userAge"] = Int(self.userAgeTextField.text!)
        userProfile?["userHeight"] = Int(self.userHeightTextField.text!)
        userProfile?["userWeight"] = Int(self.userHeightTextField.text!)
        let userInterestedInLabelIndex = self.userInterestedInLabel.selectedSegmentIndex
        if userInterestedInLabelIndex == 0 {
          userProfile?["userInterestedIn"] = "male"
        } else {
          userProfile?["userInterestedIn"] = "female"
        }
        let userHipHopIdentityIndex = self.userHipHopIdentity.selectedSegmentIndex
        
        if userHipHopIdentityIndex == 0 {
          userProfile?["userHipHopIdentity"] = "Actor"
        } else if userHipHopIdentityIndex == 1 {
          userProfile?["userHipHopIdentity"] = "Director"
        } else if userHipHopIdentityIndex == 2 {
          userProfile?["userHipHopIdentity"] = "DJ"
        } else {
          userProfile?["userHipHopIdentity"] = "Listener"
        }
        userProfile?["emailId"] = self.emailIdTextField.text
        userProfile?["userCity"] = self.userCityTextField.text
        userProfile?["userState"] = self.userStateTextField.text
        userProfile?["userCountry"] = self.userCountryTextField.text
        userProfile?["userProfession"] = self.userProfessionTextField.text
        userProfile?["userPreferenceMinAge"] = Int(self.userPreferenceMinAgeTextField.text!)
        userProfile?["userPreferenceMaxAge"] = Int(self.userPreferenceMaxAgeTextField.text!)
        userProfile?["userPreferenceMinHeight"] = Int(self.userPreferenceMinHeight.text!)
        userProfile?["userPreferenceMaxHeight"] = Int(self.userPreferenceMaxHeight.text!)
        userProfile?["userOtherInterests"] = self.userOtherInterestsTextView.text
        
        
        let imageData = UIImageJPEGRepresentation(self.userProfilePicImageView.image!, 1.0)
        let imageName = UUID().uuidString
        let extensionString: String = ".jpg"
        
        let imageFile = PFFile(name:imageName + extensionString, data:imageData!)
        userProfile?["userProfilePic"] = imageFile
        userProfile?.saveInBackground { (success: Bool, error: Error?) in
          if(success){
            print("user succesfully created into table")
            // Send user to matches section
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let matchesVC = storyboard.instantiateViewController(withIdentifier: "HomeTabBarController")
            
            // After update user can't go back to profile set up section
            matchesVC.navigationItem.hidesBackButton = true
            matchesVC.childViewControllers[0].navigationItem.hidesBackButton = true
            self.show(matchesVC, sender: self)
          } else {
            print("unable to save the data into user class")
          }
        }
      })
    }
  }
  
  
  
  //    @IBAction func onTapUserProfilePicImageView(_ sender: UITapGestureRecognizer) {
  
  //        let vc = UIImagePickerController()
  //        vc.delegate = self
  //        vc.allowsEditing = true
  //
  //        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
  //            vc.sourceType = .photoLibrary
  //        }
  //
  //        /*
  //         if UIImagePickerController.isSourceTypeAvailable(.camera) {
  //         print("Camera is available 📸")
  //         vc.sourceType = .camera
  //         } else {
  //         print("Camera 🚫 available so we will use photo library instead")
  //         vc.sourceType = .photoLibrary
  //         }
  //         */
  //
  //        self.present(vc, animated: true, completion: nil)
  
  
  //    }
  
  
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    //        // Get the image captured by the UIImagePickerController
    //        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
    //         let imageData = UIImageJPEGRepresentation(originalImage, 1.0)
    //        dismiss(animated: true) {
    //
    //            self.userProfilePicImaveView.image = UIImage(data: imageData!)
    //
    //
    //        }
    
  }
  
  
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
   
   // Configure the cell...
   
   return cell
   }
   */
  
  /*
   // Override to support conditional editing of the table view.
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the specified item to be editable.
   return true
   }
   */
  
  /*
   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
   if editingStyle == .delete {
   // Delete the row from the data source
   tableView.deleteRows(at: [indexPath], with: .fade)
   } else if editingStyle == .insert {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }
   }
   */
  
  /*
   // Override to support rearranging the table view.
   override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
   
   }
   */
  
  /*
   // Override to support conditional rearranging of the table view.
   override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
