//
//  DetailViewController.swift
//  LoveAndHiphop
//
//  Created by Mogulla, Naveen on 5/10/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import Parse
import AFNetworking
import SwiftyGif

protocol DetailedViewControllerDelegate: class {
    func didLikeUnlikeUser(user: String, didLike: Bool)
}

class DetailViewController: UITableViewController {

    @IBOutlet weak var photoScrollView: UIScrollView!
    @IBOutlet weak var animatedImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var hiphopIdentityLabel: UILabel!
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var otherInterestsLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var emailIdLabel: UILabel!
    @IBOutlet weak var likeUnlikeImageView: UIButton!
    @IBOutlet weak var cancelImageView: UIButton!
    
    var userObject: UserObject?
    var likedByUsers: [String]?
    weak var delegate: DetailedViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        
         self.updateProfile()
    }
    
    
    func loadOtherImages(success: @escaping ([URL]) -> (), failure: @escaping () -> ()){

        let userObjectId: String = userObject!.userObjectId!

        let query = PFQuery(className: "photos")
        query.whereKey("uploadedBy_userid", equalTo: userObjectId)
        query.findObjectsInBackground { (pfObjects: [PFObject]?, error: Error?) in
            if error == nil {
                var imageUrlArray = [URL]()
                
                for pfObject in pfObjects!{
                    let imageFile = pfObject["personal_image"] as? PFFile
                    let imageFileURL: String = imageFile!.url!
                    let imageUrl = URL(string: imageFileURL)
                    let imageView = UIImageView()
                    imageView.setImageWith(imageUrl!)
                    imageView.contentMode = .scaleAspectFit
                    imageUrlArray.append(imageUrl!)
                    print(imageUrlArray.count)
                    
                }
                if imageUrlArray != nil {
                    success(imageUrlArray)
                }
            } else {
                print("user doesnt have any extra images")
            }
        }
    }
    
    @IBAction func onClickLike(_ sender: UIButton) {

        print("Like button has been clicked in detailed view")
        let selectedUserObjectId: String = (self.userObject?.userObjectId)!
        let currentUserObjectId: String = PFUser.current()!.objectId!

        if let likedByUsers = likedByUsers {
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
    
    
    
    @IBAction func onClickCancel(_ sender: UIButton) {
        print("Like button has been clicked in detailed view")

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
                                self.likedByUsers = curLikedByUsers
                                self.updateProfile()

                                //Passing the un-like status back to matches view controller
                                self.delegate?.didLikeUnlikeUser(user: unlikedUserObjectId, didLike: false)
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
                        self.likedByUsers = likedByUsers
                        self.updateProfile()

                        //Passing the like status back to matches view controller
                        self.delegate?.didLikeUnlikeUser(user: likedUserObjectId, didLike: true)
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

                            self.likedByUsers = curLikedByUsers
                            //Updating the heart icon to red color
                            self.updateProfile()

                            //Passing the like status back to matches view controller
                            self.delegate?.didLikeUnlikeUser(user: likedUserObjectId, didLike: true)

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

    func updateProfile() {

        self.photoScrollView.delegate = self
        let imageView = UIImageView()
        imageView.setImageWith((self.userObject?.profileImageUrl)!)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: self.photoScrollView.frame.width, height: self.photoScrollView.frame.height)
        self.photoScrollView.contentSize.width = self.photoScrollView.frame.width
        self.photoScrollView.addSubview(imageView)

        self.loadOtherImages(success: { (imageUrlArray: [URL]) in
            for i in 0..<imageUrlArray.count {
                let imageView = UIImageView()
                imageView.setImageWith((imageUrlArray[i]))
                imageView.contentMode = .scaleAspectFit
                let xPosition = self.view.frame.width * CGFloat(i+1)
                imageView.frame = CGRect(x: xPosition, y: 8, width: self.photoScrollView.frame.width, height: self.photoScrollView.frame.height)
                self.photoScrollView.contentSize.width = self.photoScrollView.frame.width * CGFloat(i+2)
                imageView.isUserInteractionEnabled = false
                self.photoScrollView.addSubview(imageView)
            }
            }, failure: {

        })

        let gifmanager = SwiftyGifManager(memoryLimit:40)
        let gif = UIImage(gifName: "loveme_or_not_gif.gif")
        self.animatedImageView.setGifImage(gif, manager: gifmanager)

        self.nameLabel.text = userObject?.fullName
        self.occupationLabel.text = userObject?.occupation
        self.hiphopIdentityLabel.text = userObject?.hiphopIdentity
        self.aboutLabel.text = userObject?.about
        self.locationLabel.text = userObject?.location
        self.emailIdLabel.text = userObject?.email
        self.tableView.reloadData()


        //TODO: The local array does not retain data after coming back from detailed view
        if let likedByUsers = likedByUsers {
            if likedByUsers.contains((PFUser.current()?.objectId!)!) {
                likeUnlikeImageView.setImage(UIImage(named: "Heart-Liked"), for: UIControlState.normal)
            } else {
                likeUnlikeImageView.setImage(UIImage(named: "Heart-Unliked"), for: UIControlState.normal)
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
}
