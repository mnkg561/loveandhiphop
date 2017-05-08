//
//  MatchDetailedViewController.swift
//  LoveAndHiphop
//
//  Created by Mogulla, Naveen on 5/7/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//


import UIKit
import Parse

class MatchDetailedViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileType: UILabel!
    @IBOutlet weak var profileLocation: UILabel!
    @IBOutlet weak var profileAge: UILabel!
    @IBOutlet weak var profileGender: UILabel!
    @IBOutlet weak var profileInterestedIn: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var user: PFUser!
    var likedByUsers: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Displaying the detailed view
        updateProfile()
        
    }
    
    func updateProfile() {
        
        let name = user.object(forKey: "name")! as! String
        let age = user.object(forKey: "age")! as! String
        profileName.text =  name+", "+age
        profileGender.text = user.object(forKey: "gender") as! String?
        profileType.text = user.object(forKey: "membershipType") as! String?
        profileLocation.text = user.object(forKey: "location") as! String?
        profileInterestedIn.text = user.object(forKey: "interested_gender")! as? String
        
        let profilePictureFile = user.object(forKey: "picture") as? PFFile
        let pictureURL: String = profilePictureFile!.url!
        let profilePictureURL = URL(string: pictureURL)
        profileImageView.setImageWith(profilePictureURL!)
        
        if let likedByUsers = likedByUsers {
            if likedByUsers.contains((PFUser.current()?.objectId!)!) {
                likeButton.setImage(UIImage(named: "like-on"), for: UIControlState.normal)
            } else {
                likeButton.setImage(UIImage(named: "like-off"), for: UIControlState.normal)
            }
        }
    }
    
    
    @IBAction func onLike(_ sender: UIButton) {
        
        print("Like button has been clicked")
        self.addLikedByUser(likedUser: self.user, likedByUser: PFUser.current()!)
        
        /**
         * On like,
         * 1. Check and see if the current user is already in the array of likedByUsers of the user being liked, in the local
         * 2. If the current user is already in the likedByUsers array, then
         *    a) Unlike the heart button
         *    b) Remove the current user from the local array of likedByUsers of the user being liked
         *    c) Remove the current user from the array of likedByUsers in the Like Table
         * 3. If the current user is not already in the likedByUsers array, then
         *    a) like the heart button
         *    b) Add the current user into the local array of likedByUsers of the user being liked
         *    c) Add the current user into the array of likedByUsers in the Like Table
         **/
        
        
    }
    
    func removeLikedByUser(likedUser: PFUser, likedByUser: PFUser) {
        //Remove the currentUser from the local likedByUser array
        
        //Remove the current User from the Like table's likedByUser array
        //Updating the Like in table
        let query = PFQuery(className: "Like")
        query.whereKey("user", equalTo: likedUser)
        query.findObjectsInBackground { (likeTableResults: [PFObject]?, error: Error?) in
            
            //This means there is just one row which is the expected case
            if(likeTableResults?.count == 1){
                
                //Get the array of likedByUsers
                let likeTableRow = likeTableResults?.first
                var curLikedByUsers: [String] = likeTableRow?.object(forKey: "likedByUsers") as! [String]
                
                //Checking if the current user is already in this array of likedByUsers
                if curLikedByUsers.contains(likedByUser.objectId!) {
                    
                    //Updating the heart icon to red color
                    //                    self.likeButton.imageView?.image = UIImage(named: "like-on")
                    
                } else {
                    //Adding the current user into the array of likedByUsers
                    curLikedByUsers.append(likedByUser.objectId!)
                    likeTableRow?.setObject(curLikedByUsers, forKey: "likedByUsers")
                    likeTableRow?.saveInBackground(block: { (success: Bool, error: Error?) in
                        if(success) {
                            print("Success! Current user has been to likedByUsers array")
                            self.likedByUsers = curLikedByUsers
                            //Updating the heart icon to red color
                            self.updateProfile()
                            //                            self.likeButton.imageView?.image = UIImage(named: "like-on")
                        } else {
                            print("Error! Could not add current user to likedByUsers array")
                            print(error)
                        }
                    })
                }
                
            }
            
            
        }
        
    }
    
    // likedByUser is the current user, likedUser is the profile of the user whose cell was clicked
    func addLikedByUser(likedUser: PFUser, likedByUser: PFUser) {
        
        //Updating the Like in table
        let query = PFQuery(className: "Like")
        query.whereKey("user", equalTo: likedUser)
        query.findObjectsInBackground { (likeTableResults: [PFObject]?, error: Error?) in
            
            //This means there are no existing likes for this user
            if (likeTableResults?.isEmpty)! {
                
                var likedByUsers = [String]()
                likedByUsers.append((PFUser.current()?.objectId)!)
                
                //Creating a new row to map likedUser and likedByUsers array
                let likeTable = PFObject(className:"Like")
                likeTable["user"] = likedUser
                likeTable["likedByUsers"] = likedByUsers
                likeTable.saveInBackground(block: { (succcess: Bool, error: Error?) in
                    if(succcess) {
                        print("Success! New row added to map likedUser and likedByUsers array")
                        self.likedByUsers = likedByUsers
                        self.updateProfile()
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
                if curLikedByUsers.contains(likedByUser.objectId!) {
                    
                    //Updating the heart icon to red color
                    //                    self.likeButton.imageView?.image = UIImage(named: "like-on")
                    
                } else {
                    //Adding the current user into the array of likedByUsers
                    curLikedByUsers.append(likedByUser.objectId!)
                    likeTableRow?.setObject(curLikedByUsers, forKey: "likedByUsers")
                    likeTableRow?.saveInBackground(block: { (success: Bool, error: Error?) in
                        if(success) {
                            print("Success! Current user has been to likedByUsers array")
                            self.likedByUsers = curLikedByUsers
                            //Updating the heart icon to red color
                            self.updateProfile()
                            //                            self.likeButton.imageView?.image = UIImage(named: "like-on")
                        } else {
                            print("Error! Could not add current user to likedByUsers array")
                            print(error)
                        }
                    })
                }
                
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
    
    
    //    func addLiked(forUser: PFUser, byUser: PFUser) {
    //
    //        let likeQuery = PFQuery(className: "Like")
    //        likeQuery.whereKey("user", equalTo: forUser)
    //        likeQuery.findObjectsInBackground { (obj: [PFObject]?, error: Error?) in
    //            if error == nil {
    //                if var likedByUsers = obj as? [PFUser] {
    //                    if !likedByUsers.contains(byUser) {
    //                        likedByUsers.append(byUser)
    //                        forUser.setObject(likedByUsers, forKey: "likedByUsers")
    //                    }
    //                } else {
    //                    let likedByUsers = [byUser]
    //                    forUser.setObject(likedByUsers, forKey: "likedByUsers")
    //                }
    //                forUser.saveInBackground(block: { (success: Bool, error: Error?) in
    //                    if success {
    //                        self.updateProfile()
    //                    }
    //                })
    //                
    //            } else {
    //                
    //            }
    //        }
    //    }
    
}
