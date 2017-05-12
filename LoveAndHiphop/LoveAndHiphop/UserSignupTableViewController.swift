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
  
  // MARK: Properties
  let genders = ["male", "female"]
  @IBOutlet weak var genderPreferenceControl: UISegmentedControl!
  
  let hipHopIdentities = ["Artist", "Producer", "DJ", "Fan", "Model", "Director"]
  @IBOutlet weak var hipHopIdentityControl: UISegmentedControl!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var genderControl: UISegmentedControl!
  @IBOutlet weak var aboutTextView: UITextView!
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var ageTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var occupationTextField: UITextField!
  
  // Disabled fields that are wired, but not being stored in Parse
  @IBOutlet weak var heightTextField: UITextField!
  @IBOutlet weak var weightTextField: UITextField!
  @IBOutlet weak var countryTextField: UITextField!
  @IBOutlet weak var stateTextField: UITextField!
  @IBOutlet weak var cityTextField: UITextField!
  @IBOutlet weak var interestsTextView: UITextView!
  @IBOutlet weak var minAgePreferenceTextField: UITextField!
  @IBOutlet weak var maxAgePreferenceTextField: UITextField!
  @IBOutlet weak var minHeightPreferenceTextField: UITextField!
  @IBOutlet weak var maxHeightTextField: UITextField!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem
    
    profileImageView.isUserInteractionEnabled = true
    
    
    // Disable all disabled fields
    heightTextField.isEnabled = false
    weightTextField.isEnabled = false
    countryTextField.isEnabled = false
    stateTextField.isEnabled = false
    cityTextField.isEnabled = false
    interestsTextView.isEditable = false
    minAgePreferenceTextField.isEnabled = false
    maxAgePreferenceTextField.isEnabled = false
    minHeightPreferenceTextField.isEnabled = false
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
            self.firstNameTextField.isEnabled = false // Can't change
          }
          if let lastName = user["lastName"] as? String {
            self.lastNameTextField.text = lastName
            self.lastNameTextField.isEnabled = false // Can't change
          }
          if let email = user["email"] as? String {
            self.emailTextField.text = email
            self.emailTextField.isEnabled = false // Can't change email
          }
          if let gender = user["gender"] as? String {
            // Update UI to include gender
            for (i, genderTitle) in self.genders.enumerated() {
              if genderTitle == gender {
                self.genderControl.selectedSegmentIndex = i
              }
            }
          }
          
          // Load profile image
          if let profileImage = user["profileImage"] as? PFFile {
            profileImage.getDataInBackground(block: { (data: Data?, error: Error?) in
              if (error == nil) {
                self.profileImageView.image = UIImage(data: data!)
              }
            }) // End of query block for profile image
          }
        }
      }
    }) // End of fetch block
  }
  
  // MARK: Update User Profile Data in Parse
  @IBAction func onUpdateProfile(_ sender: Any) {
    
    // Update user profile data
    if PFUser.current() != nil {
      let currentUser = PFUser.current()!
      //      let query = PFQuery(className:"_User")
      
      //      query.getObjectInBackground(withId: currentUser.objectId!, block: { (user: PFObject?, error: Error?) in
      
      // MARK: User Personal Attributes
      //        if let user = user {
      let firstName = self.firstNameTextField.text!
      let lastName = self.lastNameTextField.text!
      let genderIndex = self.genderControl.selectedSegmentIndex
      let gender = self.genders[genderIndex]
      let age = self.ageTextField.text!
      let occupation = self.occupationTextField.text!
      let hipHopIdentityIndex = self.hipHopIdentityControl.selectedSegmentIndex
      let hiphopIdentity = self.hipHopIdentities[hipHopIdentityIndex]
      let about = self.aboutTextView.text!
      // Profile Image
      let imageData = UIImageJPEGRepresentation(self.profileImageView.image!, 1.0)
      let imageName = UUID().uuidString
      
      let extensionString: String = ".jpg"
      let imageFile = PFFile(name:imageName + extensionString, data:imageData!)
      let image = imageFile!
      
      let genderPreferenceIndex = self.genderPreferenceControl.selectedSegmentIndex
      let genderPreference = self.genders[genderPreferenceIndex]
      
      currentUser.setValuesForKeys(["firstName" : firstName, "lastName": lastName, "age": age, "gender": gender, "occupation": occupation, "hiphopIdentity": hiphopIdentity, "about": about, "profilePicImage": image, "genderPreference": genderPreference])
      
      currentUser.saveInBackground(block: { (success: Bool, error: Error?) in
        if (success) {
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
        
      })
      //          user["firstName"] = firstName
      //          user["lastName"] = self.lastNameTextField.text
      //
      //          let genderIndex = self.genderControl.selectedSegmentIndex
      //          user["gender"] = self.genders[genderIndex]
      //
      //          user["age"] = self.ageTextField.text
      //          user["occupation"] = self.occupationTextField.text
      //
      //          let hipHopIdentityIndex = self.hipHopIdentityControl.selectedSegmentIndex
      //          user["hiphopIdentity"] = self.hipHopIdentities[hipHopIdentityIndex]
      //
      //          user["about"] = self.aboutTextView.text
      
      
      
      //          let imageFile = PFFile(name:imageName + extensionString, data:imageData!)
      //          user["profileImage"] = imageFile
      
      
      /* Location Details
       userProfile?["city"] = self.userCityTextField.text
       userProfile?["state"] = self.userStateTextField.text
       userProfile?["country"] = self.userCountryTextField.text
       */
      
      /* Contact details
       
       */
      
      
      // MARK: User Matches
      
      //          let genderPreferenceIndex = self.genderPreferenceControl.selectedSegmentIndex
      //          user["genderPreference"] = self.genders[genderPreferenceIndex]
      
      /* Preference Details
       userProfile?["userHeight"] = Int(self.userHeightTextField.text!)
       userProfile?["userWeight"] = Int(self.userHeightTextField.text!)
       userProfile?["userPreferenceMinAge"] = Int(self.userPreferenceMinAgeTextField.text!)
       userProfile?["userPreferenceMaxAge"] = Int(self.userPreferenceMaxAgeTextField.text!)
       userProfile?["userPreferenceMinHeight"] = Int(self.userPreferenceMinHeight.text!)
       userProfile?["userPreferenceMaxHeight"] = Int(self.userPreferenceMaxHeight.text!)
       userProfile?["userOtherInterests"] = self.userOtherInterestsTextView.text
       */
      
      
      
      // Save udpated profile
      //          user.saveInBackground(block: { (success: Bool, error: Error?) in
      //            if (success) {
      //              print("user succesfully created into table")
      //
      //              // Send user to matches section
      //              let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
      //              let matchesVC = storyboard.instantiateViewController(withIdentifier: "HomeTabBarController")
      //
      //              // After update user can't go back to profile set up section
      //              matchesVC.navigationItem.hidesBackButton = true
      //              matchesVC.childViewControllers[0].navigationItem.hidesBackButton = true
      //              self.show(matchesVC, sender: self)
      //            } else {
      //              print("unable to save the data into user class")
      //            }
      //          }) // End of save user data block
      //
      //        } else {
      //          print("Cannot update user profile. User object query did not return any results")
      //        }
      //      }) // End of object query block
      //    } else {
      //      print("Cannot update user profile. User is not logged in.")
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
