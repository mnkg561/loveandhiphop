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

class MatchesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MatchCellDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var cancelImageView: MatchCell!
  @IBOutlet weak var likeUnlikeImageView: MatchCell!

  var profileMatchesCount: Int = 0
  var likedByUsersDict: Dictionary<String, [String]> = Dictionary()
  
  var currentUser: PFUser? = nil
  var currentUserGender: String? = nil
  var currentUserGenderPreference: String? = nil
  var currentUserObjectId: String = ""
  var currentCancelledMatches: [String]?
  var currentUserObject: UserObject?
  var userObjects: [UserObject]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 200
    
    // Do any additional setup after loading the view, typically from a nib.
    
    //Find and set the current user's gender, interested_gender and objectId of user table
    self.currentUser = PFUser.current()
    if(self.currentUser != nil) {
        setCurrentUserDetails()

        //Load matches for the current user
        loadMatchesForCurrentUser()

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
    
    let query: PFQuery = PFUser.query()!
    query.whereKey("objectId", equalTo: PFUser.current()!.objectId!)
    query.getFirstObjectInBackground { (currentUser: PFObject?, error: Error?) in
        if error == nil {
            self.currentUserObject = UserObject.currentUser(pfObject: currentUser!)
        }
    }

    //Find the current user's gender, gender preference and object ID
    self.currentUserObjectId = self.currentUser!.objectId!
    self.currentUserGender = self.currentUser!.object(forKey: "gender") as! String?
    self.currentUserGenderPreference = self.currentUser?.object(forKey: "genderPreference") as! String?
    self.currentCancelledMatches = self.currentUser?.object(forKey: "cancelledMatches") as! [String]?
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
    
    print("Current User Details:")
    print("Gender Preference: \(self.currentUserGenderPreference)")

    let query: PFQuery = PFUser.query()!                                  // all users
    query.whereKey("objectId", notEqualTo: currentUserObjectId)           // who are not current user
    query.whereKey("gender", equalTo: currentUserGenderPreference!)       // who match the gender preference of current user
    query.whereKey("objectId", notContainedIn: (self.currentUserObject?.cancelledMatches) ?? []) // who are not in cancelledMatches of current user
    query.findObjectsInBackground{ (profileMatches: [PFObject]?, error: Error?) in

            if profileMatches != nil {
                self.userObjects = UserObject.userObjectWithArray(pfObjects: profileMatches!)
                self.profileMatchesCount = (profileMatches?.count)!

                //Create the likedByUsers dictionary
                self.createLikedByUsersDictionary()
                self.tableView.reloadData()

            } else {
                print("Sorry! No users available fot this app")
                print("error: \(error?.localizedDescription)")
            }
        }
    }

    func createLikedByUsersDictionary() {

        for user in self.userObjects! {

            let userObjectId: String = user.userObjectId!

            let query = PFQuery(className: "Like2")
            query.whereKey("userObjectId", equalTo: userObjectId)
            query.findObjectsInBackground { (likeTableResults: [PFObject]?, error: Error?) in
                if (likeTableResults?.count) == 1 {
                    let likeTableResult = likeTableResults?.first
                    let likedByUsers = likeTableResult?.object(forKey: "likedByUsers") as! [String]
                    self.likedByUsersDict[userObjectId] = likedByUsers
                }
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
    let matchCell = tableView.dequeueReusableCell(withIdentifier: "MatchCell", for: indexPath) as! MatchCell
    matchCell.userObject = self.userObjects?[indexPath.row]
    matchCell.delegate = self
    
    return matchCell
    
  }

    func onLikeClicked (selectedUserObject: UserObject) {
        print("User has clicked like/unlike in Matches View Controller")
        
        let selectedUserObjectId: String = (selectedUserObject.userObjectId)!
        let currentUserObjectId: String = (self.currentUserObject?.userObjectId)!
        
        if let likedByUsers = likedByUsersDict[selectedUserObjectId] {
            if likedByUsers.contains(currentUserObjectId) {
                //Unlike the match
                self.removeLikedByUser(unlikedUserObjectId: selectedUserObjectId, likedByUserObjectId: currentUserObjectId)
            } else {
                //Like the match
                self.addLikedByUser(likedUserObjectId: selectedUserObjectId, likedByUserObjectId: currentUserObjectId)
            }
        } else {
            //Like the match since the likeByUsers is nil
            self.addLikedByUser(likedUserObjectId: selectedUserObjectId, likedByUserObjectId: currentUserObjectId)
        }
    }


    /*
     * Get the cancelled users for the current user
     * if the selected user is not already in it, add it to the list and store it back in Parse User table under cancelledMatches
     * Reload the table - the matching algorithm should not show matches who are in the list of cancelledMatches in user table
     */
    func onCancelClicked (cancelledUserObject: UserObject) {
        print("User has clicked cancel in Matches View Controller")
        //Get the userObject of the user who was cancelled
        let cancelledUserObjectId: String = (cancelledUserObject.userObjectId)!

        //Get the currentUser's userObject and the list of cancelledMatches for the current user. Add the cancelledUser to cancelledMatches array in User table
        //Get the current user's cancelledMatches
        var cancelledMatches: [String] = (self.currentUserObject?.cancelledMatches) ?? []
        //Store the new cancelledMatches array to the user table for the current user

        cancelledMatches.append(cancelledUserObjectId)
        currentUserObject?.cancelledMatches = cancelledMatches
//        currentUserObject?.setObject(cancelledMatches, forKey: "cancelledMatches")
        currentUserObject?.saveInBackground(block: { (success: Bool, error: Error?) in
            if success {
                self.loadMatchesForCurrentUser()
            }
        })

        //Reload the table

    }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        let vc = segue.destination as! MatchDetailedViewController
    //        let indexPath = self.tableView.indexPath(for: sender as! MatchCell)
    //        let user = profileMatches?[(indexPath?.row)!]
    //        vc.user = user
    //        vc.likedByUsers = self.likedByUsersDict[(user?.objectId!)!]
    //        vc.delegate = self
    
    print(" Yea me too")
    let detailViewController = segue.destination as! DetailViewController
    
    //Get all details of the current user
    let curUserObjectId: String = (self.currentUserObject?.userObjectId)!
    let curLikedByUsers: [String] = self.likedByUsersDict[curUserObjectId] ?? []
    
    //Get all details of the selected user
    let indexPath = self.tableView.indexPath(for: sender as! MatchCell)
    let selUser = userObjects?[(indexPath?.row)!]
    let selUserObjectId: String = (selUser?.userObjectId)!
    let selLikedByUsers: [String] = self.likedByUsersDict[selUserObjectId] ?? []
    
    if(curLikedByUsers.contains(selUserObjectId) && selLikedByUsers.contains(curUserObjectId)) {
        print("The selected and current user like each other! YAY!!")
        detailViewController.isMatch = true
    } else {
        detailViewController.isMatch = false
    }

    detailViewController.likedByUsers = self.likedByUsersDict[selUserObjectId]
    detailViewController.userObject = selUser
  }
    
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("i got selected")
    tableView.deselectRow(at: indexPath, animated: true)
    
  }
  
  func removeLikedByUser(unlikedUserObjectId: String, likedByUserObjectId: String) {
        
        let query = PFQuery(className: "Like2")
        query.whereKey("userObjectId", equalTo: unlikedUserObjectId)
        query.findObjectsInBackground { (likeTableResults: [PFObject]?, error: Error?) in
            
            //This means there is just one row which is the expected case
            if(likeTableResults?.count == 1){
                
                //Get the array of likedByUsers
                let likeTableRow = likeTableResults?.first
                var curLikedByUsers: [String] = likeTableRow?.object(forKey: "likedByUsers") as! [String]
                
                //Checking if the current user is already in this array of likedByUsers
                if curLikedByUsers.contains(likedByUserObjectId) {
                    //2. Removing the current user from the array of likedByUsers
                    likeTableRow?.remove(likedByUserObjectId, forKey: "likedByUsers")
                    likeTableRow?.saveInBackground(block: { (success: Bool, error: Error?) in
                        if(success) {
                            print("Success! Current user has been removed from likedByUsers array")
                            //1. Remove the user from the local array as well
                            if let index = curLikedByUsers.index(of: likedByUserObjectId) {
                                curLikedByUsers.remove(at: index)
                                self.likedByUsersDict[unlikedUserObjectId] = curLikedByUsers
                                self.loadMatchesForCurrentUser()
                            }
                            
                        } else {
                            print("Error! Could not add current user to likedByUsers array")
                            print(error)
                        }
                    })
                } else {
                    print("Sorry! The current user cannot be deleted as they are not in the likedByUsers array for this user in Parse")
                    
                }
            }
        }
    }
    
    // likedByUser is the current user, likedUser is the profile of the user whose cell was clicked
    func addLikedByUser(likedUserObjectId: String, likedByUserObjectId: String) {
        
        //Updating the Like in table
        let query = PFQuery(className: "Like2")
        query.whereKey("userObjectId", equalTo: likedUserObjectId)
        query.findObjectsInBackground { (likeTableResults: [PFObject]?, error: Error?) in
            
            //This means there are no existing likes for this user
            if (likeTableResults?.isEmpty)! {
                
                var likedByUsers = [String]()
                likedByUsers.append((PFUser.current()?.objectId)!)
                
                //Creating a new row to map likedUser and likedByUsers array
                let likeTable = PFObject(className:"Like2")
                likeTable["userObjectId"] = likedUserObjectId
                likeTable["likedByUsers"] = likedByUsers
                likeTable.saveInBackground(block: { (succcess: Bool, error: Error?) in
                    if(succcess) {
                        print("Success! New row added to map likedUser and likedByUsers array")
                        self.likedByUsersDict[likedUserObjectId] = likedByUsers
                        self.loadMatchesForCurrentUser()
                        
                    } else {
                        print("Error! Could not add new row to map likedUser and likedByUsers array")
                        print(error)
                    }
                })
            }
            
            //This means there is just one row which is the expected case
            if(likeTableResults?.count == 1){
                
                //Get the array of likedByUsers
                let likeTableRow = likeTableResults?.first
                var curLikedByUsers: [String] = likeTableRow?.object(forKey: "likedByUsers") as! [String]
                
                //Checking if the current user is already in this array of likedByUsers
                if !curLikedByUsers.contains(likedByUserObjectId) {
                    curLikedByUsers.append(likedByUserObjectId)
                    likeTableRow?.setObject(curLikedByUsers, forKey: "likedByUsers")
                    likeTableRow?.saveInBackground(block: { (success: Bool, error: Error?) in
                        if(success) {
                            print("Success! Current user has been to likedByUsers array")
                            //Adding the current user into the array of likedByUsers
                            
                            self.likedByUsersDict[likedUserObjectId] = curLikedByUsers
                            self.loadMatchesForCurrentUser()
                        
                        } else {
                            print("Error! Could not add current user to likedByUsers array")
                            print(error)
                        }
                    })
                    
                } else {
                    print("Sorry! Already liked by this user")
                    
                }
                
            }
            
            
        }
    }
    
  
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


//      PFGeoPoint.geoPointForCurrentLocation { (geoPoint: PFGeoPoint?, error: Error?) in
//        if error == nil {
//          // do something with the new geoPoint
//          print("############# got some geo point: \(geoPoint)")
//        } else {
//          print("$$$$$$$$$$ error receiving geoPoint error: \(error?.localizedDescription)")
//        }
//      }

//    func createLikedByUsersDictionary() {
//        for user in self.profileMatches! {
//            let query = PFQuery(className: "Like")
//            query.whereKey("user", equalTo: user)
//            query.findObjectsInBackground { (likeTableResults: [PFObject]?, error: Error?) in
//                if (likeTableResults?.count) == 1 {
//                    let likeTableResult = likeTableResults?.first
//                    let likedByUsers = likeTableResult?.object(forKey: "likedByUsers") as! [String]
//                    self.likedByUsersDict[user.objectId!] = likedByUsers
//                }
//            }
//        }
//
//
//    }
//
