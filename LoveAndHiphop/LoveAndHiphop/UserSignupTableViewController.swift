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
import GooglePlaces

class UserSignupTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationSearchViewControllerDelegate {
  
  // MARK: Properties
  let genders = ["male", "female"]
  @IBOutlet weak var genderPreferenceControl: UISegmentedControl!
  @IBOutlet weak var searchContainerView: UIView!
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
    let imageTap = UITapGestureRecognizer(target: self, action: #selector(onTapProfileImage(_:)))
    profileImageView.addGestureRecognizer(imageTap)
    
    // Disable all disabled fields
    heightTextField.isEnabled = false
    weightTextField.isEnabled = false
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
                if let data = data {
                  self.profileImageView.image = UIImage(data: data)
                }
              }
            }) // End of query block for profile image
          }
          
          if let city = user["city"] as? String {
            self.cityTextField.text = city
          }
          
          if let state = user["state"] as? String {
            self.stateTextField.text = state
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
      
      let query = PFQuery(className:"_User")
      query.getObjectInBackground(withId: currentUser.objectId!, block: { (user: PFObject?, error: Error?) in
        // MARK: User Personal Attributes
        if let user = user {
          user["firstName"] = self.firstNameTextField.text
          user["lastName"] = self.lastNameTextField.text
          
          let genderIndex = self.genderControl.selectedSegmentIndex
          user["gender"] = self.genders[genderIndex]
          
          user["age"] = self.ageTextField.text
          user["occupation"] = self.occupationTextField.text
          
          let hipHopIdentityIndex = self.hipHopIdentityControl.selectedSegmentIndex
          user["hiphopIdentity"] = self.hipHopIdentities[hipHopIdentityIndex]
          
          user["about"] = self.aboutTextView.text
          
          // Profile Image
          //          let imageData = UIImageJPEGRepresentation(self.profileImageView.image!, 1.0)
          //          let imageName = UUID().uuidString
          //          let extensionString: String = ".jpg"
          //
          //          let imageFile = PFFile(name:imageName + extensionString, data:imageData!)
          //          user["profilePicImage"] = imageFile
          
          if let image = self.profileImageView.image {
            let imageData = UIImagePNGRepresentation(image)
            let imageFile = PFFile(name: "profileImage.png", data:imageData!)
            user["profilePicImage"] = imageFile
          }
          
          // Location Details
          user["city"] = self.cityTextField.text
          user["state"] = self.stateTextField.text
          user["country"] = self.countryTextField.text
          
          
          /* Contact details
           
           */
          
          
          // MARK: User Interests in Matches
          
          let genderPreferenceIndex = self.genderPreferenceControl.selectedSegmentIndex
          user["genderPreference"] = self.genders[genderPreferenceIndex]
          
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
          user.saveInBackground(block: { (success: Bool, error: Error?) in
            if (success) {
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
          }) // End of save user data block
          
        } else {
          print("Cannot update user profile. User object query did not return any results")
        }
      }) // End of object query block
    } else {
      print("Cannot update user profile. User is not logged in.")
    }
  }
  
  func onTapProfileImage(_ sender: UITapGestureRecognizer) {
    let vc = UIImagePickerController()
    vc.delegate = self
    vc.allowsEditing = true
    
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
      vc.sourceType = .photoLibrary
    }
    
    /*
     if UIImagePickerController.isSourceTypeAvailable(.camera) {
     print("Camera is available 📸")
     vc.sourceType = .camera
     } else {
     print("Camera 🚫 available so we will use photo library instead")
     vc.sourceType = .photoLibrary
     }
     */
    
    self.present(vc, animated: true, completion: nil)
  }
  
  
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    // Get the image captured by the UIImagePickerController
    let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
    let imageData = UIImageJPEGRepresentation(originalImage, 1.0)
    dismiss(animated: true) {
      
      self.profileImageView.image = UIImage(data: imageData!)
      
      self.tableView.reloadData()
    }
    
  }
  
  
  // MARK: Google Places location search
  func LocationSearchViewController(locationSearchViewController: LocationSearchViewController, selectedLocation: GMSPlace) {
    // Prepopulate user location info from Google Places search.
    // We are only interested in city, state and country.
    if let addressLines = selectedLocation.addressComponents {
      for field in addressLines {
        switch field.type {
        case kGMSPlaceTypeLocality:
          cityTextField.text = field.name
          
        case kGMSPlaceTypeAdministrativeAreaLevel1:
          stateTextField.text = field.name
          
        case kGMSPlaceTypeCountry:
          countryTextField.text = field.name
        default:
          print("Type: \(field.type), Name: \(field.name)")
        }
      }
    }
  }
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // User will select a location to which can update the location in the form.
    let locationSearchVC = segue.destination as! LocationSearchViewController
    locationSearchVC.delegate = self
  }
}
