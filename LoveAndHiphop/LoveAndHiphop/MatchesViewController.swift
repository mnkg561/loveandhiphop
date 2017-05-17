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
  
  
  
  
  // MARK: Properties
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var cancelImageView: MatchCell!
  @IBOutlet weak var likeUnlikeImageView: MatchCell!
  
  // Potential matches for current user
  var matches: [PFUser] = []
  var userLikedMatches: Dictionary<String, Bool> = Dictionary()
  var matchesWhoLikedUser: Dictionary<String, Bool> = Dictionary()
  var cancelledMatches: [String] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 200
    
    // MARK: Load matches
    let currentUser = PFUser.current()
    if currentUser != nil {
      
      //      let query = PFQuery(className: "_User")
      //      query.getFirstObjectInBackground(block: { (lisa: PFObject?, error: Error?) in
      //        if error != nil {
      //          print("error getting lisa")
      //        }
      //
      //        if let lisa = lisa as? PFUser {
      //          // Fake a like with current user
      //          let like = PFObject(className: "Like", dictionary: ["likedUser" : currentUser!, "user": lisa])
      //          like.saveInBackground()
      //        }
      //      })
      //
      // Update cancelled matches
      if currentUser?["cancelledMatches"] != nil {
        cancelledMatches.append(contentsOf: currentUser?["cancelledMatches"] as! [String])
      }
      loadMatches(for: currentUser!)
    }
  }
  
  // MARK: TableView Delegate
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //TODO: eventually return the count of the matches from the findMyMatches() method
    return matches.count
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let matchCell = tableView.dequeueReusableCell(withIdentifier: "MatchCell", for: indexPath) as! MatchCell
    
    let userObject = UserObject(pfObject: matches[indexPath.row])
    matchCell.userObject = userObject
    matchCell.delegate = self
    
    return matchCell
    
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("i got selected")
    tableView.deselectRow(at: indexPath, animated: true)
    
  }
  
  // MARK: Methods
  
  /**
   * Method Name: loadMatchesForCurrentUser()
   *
   * The matching algorithm will find all matches for the current user basd on:
   * 1. Users who are not the current user
   * 2. Users who match the Current User's interested gender
   * TBD - Improving the algorithm once sign up flow is complete
   **/
  func loadMatches(for user: PFUser) {
    
    // First get matches who are not current user and are the preferred gender,
    let query: PFQuery = PFUser.query()!
    query.whereKey("objectId", notEqualTo: user.objectId!)
    query.whereKey("gender", equalTo: (user["genderPreference"] as? String)!)
    query.findObjectsInBackground{ (matches: [PFObject]?, error: Error?) in
      
      if error != nil {
        print("######## Error retrieving matches: error: \(error?.localizedDescription)")
      }
      
      if let matches = matches as? [PFUser] {
        // Further filter the matches on cancelled matches by the user
        let cancelledMatches = user["cancelledMatches"] as? [String]
        print("99999999990999999999 HERE ARE USERS LIST OF CANCELLLED MATCHES, cancelledMatches: \(cancelledMatches)")
        for match in matches {
          if cancelledMatches != nil {
            if (!cancelledMatches!.contains(match.objectId!)) {
              self.matches.append(match)
              print("^^^^^^^***************** HEY GOT A MATCH THAT ISN'T IN CANCELLEDMATCHES, \(match["firstName"])")
            }
            else {
              print("$$$$$$$$$ THIS MATCH SHOULD NOT BE SHOWN, match: \(match["firstName"])")
            }
          } else {
            self.matches = matches
          }
        }
        
        // Get the users who liked current users
        // and vice versa.
        self.getMatchesWhoLike(user: user)
        //        self.getMatchesWhoUserLike(userObject)
        self.tableView.reloadData()
        
      }
    }
  }
  
  func getMatchesWhoLike(user: PFUser) {
    
    // Go through list of potential matches for current user
    for potentialMatch in matches {
      print("#######$$$$$$$$$$$$ GOT A POTENTIAL MATCH LETS SEE WHO LIKE THEM")
      let potentialMatchObjectId: String = potentialMatch.objectId!
      
      // Get the users who have liked this potential match
      let query = PFQuery(className: "Like")
      query.whereKey("user", equalTo: potentialMatch) // Is match user
      query.whereKey("likedUser", equalTo: user)
      query.getFirstObjectInBackground(block: { (potentialMatchUserLike: PFObject?, error: Error?) in
        if error != nil {
          print("############## Error retrieving users who liked current user, error: \(error?.localizedDescription)")
        }
        
        // Update matchLikedBy to include who liked this match
        if potentialMatchUserLike != nil {
          print("$$$$$$$$$$ Current match HAS LIKED CURRENT USER match: \(potentialMatch["firstName"])!")
          self.matchesWhoLikedUser[potentialMatchObjectId] = true
        }
      })
    }
  }
  
  func getMatchesWhoUserLike(_ user: UserObject) {
    // Go through list of potential matches for current user
    for potentialMatch in matches {
      print("#######$$$$$$$$$$$$ GOT A POTENTIAL MATCH LETS SEE WHO LIKE THEM")
      
      // Get the users who have liked this potential match
      let query = PFQuery(className: "Like")
      query.whereKey("user", equalTo: user)
      query.whereKey("likedUser", equalTo: potentialMatch)
      query.findObjectsInBackground(block: { (users: [PFObject]?, error: Error?) in
        if error != nil {
          print("############## Error retrieving users who liked current user, error: \(error?.localizedDescription)")
        }
        
        if let users = users {
          for user in users {
            self.userLikedMatches[user.objectId!] = true
            print("########### CURRENT USER LIKES THIS USER, user: \(user["userObjectId"])")
          }
        }
      })
      
    }
  }
  
  
  // MARK: Delegate Methods
  @objc internal func MatchCell(matchCell: MatchCell, didLikeUser value: Bool) {
    let indexPath = tableView.indexPath(for: matchCell)
    let likedUser = matches[(indexPath?.row)!]
    
    let like = PFObject(className: "Like", dictionary: ["user": PFUser.current()!, "likedUser": likedUser])
    like.saveInBackground { (success: Bool, error: Error?) in
      if error != nil {
        // Will have to adjust UI to display error
        print("Error updating like status, error: \(error?.localizedDescription)")
      } else {
        print("######### User liked!")
      }
    }
  }
  
  @objc internal func MatchCellCancelled(matchCell: MatchCell, didCancelUser value: Bool) {
    let indexPath = tableView.indexPath(for: matchCell)
    let cancelledUser = matches[(indexPath?.row)!]
    cancelledMatches.append(cancelledUser.objectId!)
    
    PFUser.current()?.addUniqueObjects(from: cancelledMatches, forKey: "cancelledMatches")
    PFUser.current()?.saveInBackground(block: { (success: Bool, error: Error?) in
      if error != nil {
        print("###### Error adding user to cancelled matches, error: \(error?.localizedDescription)")
      }
      
      if success {
        print("$$$$$$$$$$ USER WAS CANCELLED!!!!!!!!!!!!")
      }
    })
  }
  
  
  
  // MARK: Navigation
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
    let user = matches[(indexPath?.row)!]
    //    let userObjectId: String = (user.userObjectId)!
    //    detailViewController.likedByUsers = self.matchLikedBy[userObjectId]
    let userObject = UserObject(pfObject: user)
    detailViewController.userObject = userObject
  }
  
}





//  func onLikeClicked(user: UserObject) {
//    print("User has clicked like/unlike in Matches View Controller")
//    //        let selectedUserObjectId: String = (self.userObject?.userObjectId)!
//    //        let currentUserObjectId: String = PFUser.current()!.objectId!
//    //
//    //        if let likedByUsers = likedByUsers {
//    //            if likedByUsers.contains(currentUserObjectId) {
//    //                //Unlike the match
//    //                self.removeLikedByUser(unlikedUserObjectId: selectedUserObjectId, likedByUserObjectId: currentUserObjectId)
//    //            } else {
//    //                //Like the match
//    //                self.addLikedByUser(likedUserObjectId: selectedUserObjectId, likedByUserObjectId: currentUserObjectId)
//    //            }
//    //        } else {
//    //            //Like the match since the likeByUsers is nil
//    //            self.addLikedByUser(likedUserObjectId: selectedUserObjectId, likedByUserObjectId: currentUserObjectId)
//    //
//    //        }
//  }
//
//




/*
 * Get the cancelled users for the current user
 * if the selected user is not already in it, add it to the list and store it back in Parse User table under cancelledMatches
 * Reload the table - the matching algorithm should not show matches who are in the list of cancelledMatches in user table
 */
//  func onCancelClicked (cancelledUserObject: UserObject) {
//    print("User has clicked cancel in Matches View Controller")
//    //Get the userObject of the user who was cancelled
//    let cancelledUserObjectId: String = (cancelledUserObject.userObjectId)!
//
//    //Get the currentUser's userObject and the list of cancelledMatches for the current user. Add the cancelledUser to cancelledMatches array in User table
//    //Get the current user's cancelledMatches
//    var cancelledMatches: [String] = (PFUser.current()["cancelledMatches"]) ?? []
//    //Store the new cancelledMatches array to the user table for the current user
//
//    cancelledMatches.append(cancelledUserObjectId)
//    currentUserObject?.cancelledMatches = cancelledMatches
//    //        currentUserObject?.setObject(cancelledMatches, forKey: "cancelledMatches")
//    currentUserObject?.saveInBackground(block: { (success: Bool, error: Error?) in
//      if success {
//        self.loadMatchesForCurrentUser()
//      }
//    })
//
//    //Reload the table
//
//  }
//
//






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


//      query.getFirstObjectInBackground(block: { (potentialMatchUserLike: PFObject?, error: Error?) in
//        if error != nil {
//          print("############## Error retrieving users who liked current user, error: \(error?.localizedDescription)")
//        }
//
//        // Update matchLikedBy to include who liked this match
//        //  if potentialMatchUserLike != nil {
//        //  print("$$$$$$$$$$ Current match HAS LIKED CURRENT USER match: \(potentialMatch.firstName)!")
//        //  self.matchesWhoLikedUser[potentialMatchObjectId] = true
//        //  } else {
//        //  print("$$$$$$$$$$$ this did not like current user \(userObject.firstName)")
//        //  }
//        //  })
//
//      )}
