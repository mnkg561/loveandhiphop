//
//  FirstViewController.swift
//  LoveAndHiphop
//
//  Created by Mogulla, Naveen on 4/25/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import Parse
import AFNetworking

class MatchesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  var profileMatches: [PFUser]?
  var profileMatchesCount: Int = 0
  var likedByUsersDict: Dictionary<String, [String]> = Dictionary()
  
  var currentUserGender: String? = nil
  var currentUserInterestedGender: String? = nil
  var currentUserObjectId: String = ""
  var userObjects: [UserObject]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 200
    
    // Do any additional setup after loading the view, typically from a nib.
    
    //Find and set the current user's gender, interested_gender and objectId of user table
    setCurrentUserDetails()
    
    //Load matches for the current user
    //loadMatchesForCurrentUser()
    loadUsers()
  }
  
  
  func loadUsers(){
    let currentUser = PFUser.current()
    if currentUser != nil {
      let genderPreference = currentUser?["genderPreference"] as? String
      let query: PFQuery = PFUser.query()!
      query.whereKey("gender", equalTo: genderPreference!)
      query.findObjectsInBackground { (userObjects: [PFObject]?, error: Error?) in
        if error == nil {
          let userObjects2 = UserObject.userObjectWithArray(pfObjects: userObjects!)
          self.userObjects = userObjects2
          self.tableView.reloadData()
        } else {
          print("Error retrieving users from loadUsers, error: \(error?.localizedDescription)")
        }
      }
      
    }
  }
  
  //Implementing the MatchDetailedViewControllerDelegate Protocol
  func didLikeUnlikeUser(user: PFUser, didLike: Bool) {
    
    if(didLike) {
      self.likedByUsersDict[user.objectId!]?.append(self.currentUserObjectId)
    } else {
      if let index = likedByUsersDict[user.objectId!]?.index(of: self.currentUserObjectId) {
        likedByUsersDict[user.objectId!]?.remove(at: index)
      }
    }
  }
  
  /**
   * Method Name: setCurrentUserDetails()
   * This method sets the current user's details such as gender, interested_gender and objectId which
   * will later be used in the matching algorithm
   **/
  func setCurrentUserDetails() {
    
    //Find the current user's gender and interested_gender
    self.currentUserObjectId = PFUser.current()!.objectId!
    self.currentUserGender = PFUser.current()!.object(forKey: "gender") as! String?
    self.currentUserInterestedGender = PFUser.current()?.object(forKey: "interested_gender") as! String?
  }
  
  /**
   * Method Name: loadMatchesForCurrentUser()
   *
   * The matching algorithm will find all matches for the current user basd on:
   * 1. Users who are not the current user
   * 2. Users who match the Current User's interested gender
   * TBD - Improving the algorithm once sign up flow is complete
   **/
  func loadMatchesForCurrentUser() {
    //      PFGeoPoint.geoPointForCurrentLocation { (geoPoint: PFGeoPoint?, error: Error?) in
    //        if error == nil {
    //          // do something with the new geoPoint
    //          print("############# got some geo point: \(geoPoint)")
    //        } else {
    //          print("$$$$$$$$$$ error receiving geoPoint error: \(error?.localizedDescription)")
    //        }
    //      }
    
    let query: PFQuery = PFUser.query()!
    query.whereKeyExists("name")                                        // all users
    query.whereKey("objectId", notEqualTo: currentUserObjectId) // who are not current user
    query.findObjectsInBackground{ (profileMatches: [PFObject]?, error: Error?) in
      if profileMatches != nil {
        self.profileMatches = profileMatches as! [PFUser]?
        self.profileMatchesCount = (profileMatches?.count)!
        for user in self.profileMatches! {
          let query = PFQuery(className: "Like")
          query.whereKey("user", equalTo: user)
          query.findObjectsInBackground { (likeTableResults: [PFObject]?, error: Error?) in
            if (likeTableResults?.count) == 1 {
              let likeTableResult = likeTableResults?.first
              let likedByUsers = likeTableResult?.object(forKey: "likedByUsers") as! [String]
              self.likedByUsersDict[user.objectId!] = likedByUsers
            }
          }
        }
        self.tableView.reloadData()
      } else {
        print("Sorry! No users available fot this app")
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //TODO: eventually return the count of the matches from the findMyMatches() method
    
    
    if self.userObjects?.count != nil {
      return (self.userObjects?.count)!
    } else {
      return 0
    }
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MatchCell", for: indexPath) as! MatchCell
    
    cell.userObject = self.userObjects?[indexPath.row]
    
    return cell
    
  }
  /*
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   let matchCell = tableView.dequeueReusableCell(withIdentifier: "MatchCell", for: indexPath) as! MatchCell
   
   if let user = profileMatches?[indexPath.row] {
   
   let name = user.object(forKey: "name")! as! String
   let age = user.object(forKey: "age")! as! String
   matchCell.nameLabel.text =  name+", "+age
   matchCell.genderLabel.text = "Male"
   matchCell.registeredAsLabel.text = user.object(forKey: "membershipType") as! String?
   matchCell.locationLabel.text = user.object(forKey: "location") as! String?
   matchCell.topInterestLabel.text = user.object(forKey: "interested_gender")! as? String
   
   let profilePictureFile = user.object(forKey: "picture") as? PFFile
   if profilePictureFile != nil {
   let pictureURL: String = profilePictureFile!.url!
   let profilePictureURL = URL(string: pictureURL)
   matchCell.matchProfilePic.setImageWith(profilePictureURL!)
   }
   }
   
   return matchCell
   
   }
   
   */
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        let vc = segue.destination as! MatchDetailedViewController
    //        let indexPath = self.tableView.indexPath(for: sender as! MatchCell)
    //        let user = profileMatches?[(indexPath?.row)!]
    //        vc.user = user
    //        vc.likedByUsers = self.likedByUsersDict[(user?.objectId!)!]
    //        vc.delegate = self
    
    print(" Yea me too")
    let detailViewController = segue.destination as! DetailViewController
    let indexPath = self.tableView.indexPath(for: sender as! MatchCell)
    detailViewController.userObject = self.userObjects?[(indexPath?.row)!]
    
    
  }
  
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("i got selected")
    tableView.deselectRow(at: indexPath, animated: true)
    
  }
  
}

