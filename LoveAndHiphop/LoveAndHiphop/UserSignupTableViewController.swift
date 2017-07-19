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
  var isProfileComplete: Bool!
  var matchesRequiredFields: [UIView] {
    return [firstNameTextField, occupationTextField]
  }
  let genders = ["male", "female"]
  
  @IBOutlet weak var genderPreferenceControl: UISegmentedControl!
  @IBOutlet weak var searchContainerView: UIView!
  let hipHopIdentities = ["Fan", "Artist", "Producer", "Director", "Model", "Designer", "Dancer", "Writer"]
  var hipHopIdentityIndex: Int?
  
  @IBOutlet weak var hiphopIdentityLabel: UILabel!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var genderControl: UISegmentedControl!
  @IBOutlet weak var aboutTextView: UITextView!
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var ageTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var occupationTextField: UITextField!
  @IBOutlet weak var phoneTextField: UITextField!
  @IBOutlet weak var heightTextField: UITextField!
  @IBOutlet weak var weightTextField: UITextField!
  @IBOutlet weak var heightFeetTextField: UITextField!
  @IBOutlet weak var heightInchTextField: UITextField!
  @IBOutlet weak var countryTextField: UITextField!
  @IBOutlet weak var stateTextField: UITextField!
  @IBOutlet weak var cityTextField: UITextField!
  @IBOutlet weak var interestsTextView: UITextView!
  @IBOutlet weak var minAgePreferenceTextField: UITextField!
  @IBOutlet weak var maxAgePreferenceTextField: UITextField!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Prefill user profile data
    
    // Uncomment the following line to preserve selection between presentations
    self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem
    
    profileImageView.isUserInteractionEnabled = true
    let imageTap = UITapGestureRecognizer(target: self, action: #selector(onTapProfileImage(_:)))
    profileImageView.addGestureRecognizer(imageTap)
    
    
    // Prepopulate profile fields with stored user data
    PFUser.current()?.fetchInBackground(block: { (user: PFObject?, error: Error?) in
      if error == nil {
        if user != nil {
          let user = user!
          let pfUser = UserObject(pfObject: user)
          if let firstName = pfUser.firstName {
            self.firstNameTextField.text = firstName
            self.firstNameTextField.isEnabled = false // Can't change
          }
          if let lastName = pfUser.lastName {
            self.lastNameTextField.text = lastName
            self.lastNameTextField.isEnabled = false // Can't change
          }
          if let email = pfUser.email {
            self.emailTextField.text = email
            self.emailTextField.isEnabled = false // Can't change email
          }
          if let age = pfUser.age {
            self.ageTextField.text = age
          }
          if let gender = pfUser.gender {
            // Update UI to include gender
            for (i, genderTitle) in self.genders.enumerated() {
              if genderTitle == gender {
                self.genderControl.selectedSegmentIndex = i
              }
            }
          }
          
          // Load profile image
          if let profileImage = pfUser.profileImageFile {
            profileImage.getDataInBackground(block: { (data: Data?, error: Error?) in
              if (error == nil) {
                if let data = data {
                  self.profileImageView.image = UIImage(data: data)
                }
              }
            }) // End of query block for profile image
          }
          
          if let city = pfUser.city {
            self.cityTextField.text = city
          }
          
          if let state = pfUser.state {
            self.stateTextField.text = state
          }
          
          if let country = pfUser.country {
            self.countryTextField.text = country
          }
          
          if let aboutMe = pfUser.about {
            self.aboutTextView.text = aboutMe
          }
          
          if let occupation = pfUser.occupation {
            self.occupationTextField.text = occupation
          }
          
          if user["hiphopIdentity"] != nil {
            self.hiphopIdentityLabel.text = (user["hiphopIdentity"] as! String)
          } else if let hiphopIdentity = pfUser.hiphopIdentity {
            self.hiphopIdentityLabel.text = hiphopIdentity
          } else {
            self.hiphopIdentityLabel.text = self.hipHopIdentities[0]
          }
          
          if user["weight"] != nil {
            self.weightTextField.text = user["weight"] as! String?
          }
          
          if user["heightFeet"] != nil {
            self.heightFeetTextField.text = (user["heightFeet"] as! String)
          }
          
          if user["heightInch"] != nil {
            self.heightInchTextField.text = (user["heightInch"] as! String)
          }
          
          if user["otherInterests"] != nil {
            self.interestsTextView.text = user["otherInterests"] as! String
          }
          
          // Match preferences
          
          if user["matchMinAge"] != nil {
            self.minAgePreferenceTextField.text = user["matchMinAge"] as! String?
          }
          
          if user["matchMaxAge"] != nil {
            self.maxAgePreferenceTextField.text = user["matchMaxAge"] as! String?
          }
          
          self.isProfileComplete = user["isProfileComplete"] as! Bool
        }
      }
    }) // End of fetch block
  }
  
  // Validate required profile fields
  func isValidated() {
    var not_validated: [String] = []
    
    if (firstNameTextField.text?.isEmpty)! {
      not_validated.append("First Name")
    }
    
    if (lastNameTextField.text?.isEmpty)! {
      not_validated.append("Last Name")
    }
    
    if (ageTextField.text?.isEmpty)! {
      not_validated.append("Age")
    }
    
    if (genderPreferenceControl.selectedSegmentIndex < 0) {
      not_validated.append("Gender")
    }
    
    if ((countryTextField.text?.isEmpty)! || (stateTextField.text?.isEmpty)! || (cityTextField.text?.isEmpty)!) {
      not_validated.append("City, State, Country")
    }
    
    if (genderPreferenceControl.selectedSegmentIndex < 0) {
      not_validated.append("Gender Preference")
    }
    
    if ((minAgePreferenceTextField.text?.isEmpty)! || (maxAgePreferenceTextField.text?.isEmpty)!) {
      not_validated.append("Partner Preference Min age and Max age")
    }
    
    if ((emailTextField.text?.isEmpty)!) {
      not_validated.append("Email")
    }
    
    if not_validated.isEmpty {
      isProfileComplete = true
      self.updateProfile(self)
      return
    }
    
    isProfileComplete = false
    
    let alert = UIAlertController(title: "Missing Profile Requirements",
                                  message: "In order to use the Flirt dating feature, the required marked fields, \(not_validated) are needed. You may proceed to save your profile changes and continue to use other features of this site, or update the missing requirements.",
      preferredStyle: .alert)
    
    // Submit button
    let submitAction = UIAlertAction(title: "Submit Changes", style: .default, handler: { (action) -> Void in
      
      self.updateProfile(self)
      return
    })
    
    let cancel = UIAlertAction(title: "Update Requirements", style: .destructive, handler: { (action) -> Void in })
    
    alert.addAction(submitAction)
    alert.addAction(cancel)
    present(alert, animated: true, completion: nil)
    
  }
  
  @IBAction func onTapSaveProfile(_ sender: Any) {
    isValidated()
  }
  
  // MARK: Update User Profile Data in Parse
  func updateProfile(_ sender: Any) {
    
    // Update user profile data
    if PFUser.current() != nil {
      let currentUser = PFUser.current()!
      
      // Request current user location
      PFGeoPoint.geoPointForCurrentLocation(inBackground: { (geoPoint: PFGeoPoint?, error: Error?) in
        if error == nil {
          if let geoPoint = geoPoint {
            currentUser.setObject(geoPoint, forKey: "currentLocation")
            currentUser.saveInBackground()
          } else {
            print("No geoPoint received")
          }
        } else {
          print("Error retrieving users current location, error: \(error)")
        }
      })
      
      // MARK: User Personal Attributes
      let firstName = self.firstNameTextField.text!
      let lastName = self.lastNameTextField.text!
      let genderIndex = self.genderControl.selectedSegmentIndex
      let gender = self.genders[genderIndex]
      
      let age = self.ageTextField.text!
      if age.isEmpty {
        print("AGE IS REQUIRED!")
      }
      
      let occupation = self.occupationTextField.text!
      //      let hipHopIdentityIndex = self.hipHopIdentityControl.selectedSegmentIndex
      //      let hiphopIdentity = self.hipHopIdentities[hipHopIdentityIndex]
      let hiphopIdentity = self.hiphopIdentityLabel.text!
      let city = self.cityTextField.text!
      let state = self.stateTextField.text!
      let country = self.countryTextField.text!
      let about = self.aboutTextView.text!
      let otherInterests = self.interestsTextView.text!
      
      if (!(self.heightFeetTextField.text?.isEmpty)!) {
        currentUser.setValue(self.heightFeetTextField.text, forKey: "heightFeet")
      }
      
      if (!(self.heightInchTextField.text?.isEmpty)!) {
        currentUser.setValue(self.heightInchTextField.text, forKey: "heightInch")
      }
      
      if (!(self.weightTextField.text?.isEmpty)!) {
        currentUser.setValue(self.weightTextField.text, forKey: "weight")
      }
      
      // Profile Image
      let imageData = UIImageJPEGRepresentation(self.profileImageView.image!, 1.0)
      let imageName = UUID().uuidString
      
      let extensionString: String = ".jpg"
      let imageFile = PFFile(name:imageName + extensionString, data:imageData!)
      let image = imageFile!
      
      // Match Preferences
      var genderPreference: String = ""
      let genderPreferenceIndex = self.genderPreferenceControl.selectedSegmentIndex
      if genderPreferenceIndex < 0 {
        print("Gender preference IS REQUIRED!")
      } else {
        if genderPreferenceIndex == 0 {
          genderPreference = "male"
        } else {
          genderPreference = "female"
        }
      }
      
      if (!(self.minAgePreferenceTextField.text?.isEmpty)!) {
        currentUser.setValue(self.minAgePreferenceTextField.text, forKey: "matchMinAge")
      }
      
      if (!(self.maxAgePreferenceTextField.text?.isEmpty)!) {
        currentUser.setValue(self.maxAgePreferenceTextField.text, forKey: "matchMaxAge")
      }
      
      currentUser.setValuesForKeys(["firstName" : firstName, "lastName": lastName, "age": age, "gender": gender,
                                    "occupation": occupation, "hiphopIdentity": hiphopIdentity, "about": about,
                                    "profilePicImage": image, "genderPreference": genderPreference, "city": city,
                                    "state": state, "country": country, "otherInterests": otherInterests, "isProfileComplete": isProfileComplete])
      
      currentUser.saveInBackground(block: { (success: Bool, error: Error?) in
        if (success) {
          print("user succesfully created into table")
          
          let alert = UIAlertController(title: "Profile Successfully Updated",
                                        message: "",
                                        preferredStyle: .alert)
          
          let close = UIAlertAction(title: "Close", style: .default, handler: { (action) -> Void in })
          
          alert.addAction(close)
          self.present(alert, animated: true, completion: nil)
          // Send user to profile preview section
          let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
          let myProfileVC = storyboard.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
          
          // After update user can't go back to profile set up section
          myProfileVC.navigationItem.hidesBackButton = true
          myProfileVC.activeViewController = myProfileVC.userProfileViewController
          //          viewProfileVC.childViewControllers[0].navigationItem.hidesBackButton = true
          self.show(myProfileVC, sender: self)
        } else {
          print("Unable to save the data into user class, error: \(error?.localizedDescription)")
        }
      })
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
      
      // Update current user profile Image
      let imageData = UIImageJPEGRepresentation(self.profileImageView.image!, 1.0)
      let imageName = UUID().uuidString
      let extensionString: String = ".jpg"
      let imageFile = PFFile(name:imageName + extensionString, data:imageData!)
      let image = imageFile!
      PFUser.current()?.setObject(image, forKey: "profilePicImage")
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
          print("City: \(field.name)")
        case kGMSPlaceTypeAdministrativeAreaLevel1:
          stateTextField.text = field.name
          print("State: \(field.name)")
        case kGMSPlaceTypeCountry:
          countryTextField.text = field.name
          print("COUNTRY: \(field.name)")
        default:
          print("Type: \(field.type), Name: \(field.name)")
        }
      }
    } else {
      print("Error getting data, selectedLocation: \(selectedLocation)")
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
