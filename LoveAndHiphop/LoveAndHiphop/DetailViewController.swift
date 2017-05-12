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
    
    var userObject: UserObject?
    
    override func viewWillAppear(_ animated: Bool) {
        
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
        

    }
    
    
    func loadOtherImages(success: @escaping ([URL]) -> (), failure: @escaping () -> ()){
        let query = PFQuery(className: "photos")
        query.whereKey("uploadedBy_userid", equalTo: self.userObject?.userObjectId!)
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
    }
    
    
    
    @IBAction func onClickCancel(_ sender: UIButton) {
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
