//
//  UserProfileViewController.swift
//  LoveAndHiphop
//
//  Created by Mogulla, Naveen on 5/8/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import Parse
import AFNetworking
import SwiftyGif
import MBProgressHUD

class UserProfileViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var emailIdLabel: UILabel!

    @IBOutlet weak var otherInterestsLabel: UILabel!
  @IBOutlet weak var photosScrollView: UIScrollView!

    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var hiphopIdentityLabel: UILabel!
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var currentUser: UserObject?
    var imageUrlArray: [URL]?
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
        //photosScrollView.frame = view.frame
//      tableView.contentInset = UIEdgeInsetsMake(-90, 0, 0, 0);
//      automaticallyAdjustsScrollViewInsets = false
      MBProgressHUD.showAdded(to: photosScrollView, animated: true)

    }
  
  override func viewWillAppear(_ animated: Bool) {
    loadImages()
  }
    
    func loadImages(){

        let query: PFQuery = PFUser.query()!
        query.whereKey("objectId", equalTo: PFUser.current()!.objectId!)
        query.getFirstObjectInBackground { (currentUser: PFObject?, error: Error?) in
            if error == nil {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.currentUser = UserObject.currentUser(pfObject: currentUser!)
                self.aboutLabel.text = self.currentUser?.about
                self.nameLabel.text = self.currentUser?.fullName
                self.ageLabel.text = self.currentUser?.age
                self.occupationLabel.text = self.currentUser?.occupation
                self.hiphopIdentityLabel.text = self.currentUser?.hiphopIdentity
                self.otherInterestsLabel.text = self.currentUser?.otherInterests
                self.emailIdLabel.text = self.currentUser?.email
                self.locationLabel.text = self.currentUser?.location
                
                self.photosScrollView.delegate = self
                //self.photosScrollView.frame.width = self.view.frame.width
              if self.currentUser?.profileImageUrl != nil {
                let imageView = UIImageView()
                imageView.setImageWith((self.currentUser?.profileImageUrl!)!)
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true

                //imageView.clipsToBounds = true
              
                self.photosScrollView.contentSize.width = self.photosScrollView.frame.width
                self.photosScrollView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.photosScrollView.bounds.height)
              }
              
                self.loadOtherImages(success: { (imageUrlArray: [URL]) in
                    for i in 0..<imageUrlArray.count {
                        let imageView = UIImageView()
                        imageView.setImageWith((imageUrlArray[i]))
                        imageView.contentMode = .scaleAspectFit
                        let xPosition = self.view.frame.width * CGFloat(i+1)
                        imageView.frame = CGRect(x: xPosition, y: 0, width: self.view.frame.width, height: self.photosScrollView.frame.height)
                      imageView.contentMode = .scaleAspectFill
                      imageView.clipsToBounds = true
                        self.photosScrollView.contentSize.width = self.photosScrollView.frame.width * CGFloat(i+2)
                        imageView.isUserInteractionEnabled = false
                        self.photosScrollView.addSubview(imageView)
                    }
                    
                    
                    let btn1 = UIButton(type: .custom)
                    btn1.setImage(UIImage(named: "Add_Image"), for: .normal)
                    let xPosition = self.view.frame.width * CGFloat(imageUrlArray.count+1)
                    btn1.frame = CGRect(x: xPosition, y: 0, width: self.photosScrollView.frame.width, height: self.photosScrollView.frame.height)
                    btn1.addTarget(self, action: #selector(self.onClickCameraButton(_:)), for: .touchDown)
                    self.photosScrollView.contentSize.width = self.photosScrollView.frame.width * CGFloat(imageUrlArray.count+2)
                    self.photosScrollView.addSubview(btn1)

                }, failure: {
                    let btn1 = UIButton(type: .custom)
                    btn1.setImage(UIImage(named: "Add_Image"), for: .normal)
                    let xPosition = self.view.frame.width
                    btn1.frame = CGRect(x: xPosition, y: 0, width: self.photosScrollView.frame.width, height: self.photosScrollView.frame.height)
                    btn1.addTarget(self, action: #selector(self.onClickCameraButton(_:)), for: .touchDown)
                    self.photosScrollView.contentSize.width = self.photosScrollView.frame.width * CGFloat(2)
                    self.photosScrollView.addSubview(btn1)

                })
               
            }
        }
        self.tableView.reloadData()
        
    }
    
    func loadOtherImages(success: @escaping ([URL]) -> (), failure: @escaping () -> ()){
       let query = PFQuery(className: "photos")
        query.whereKey("uploadedBy_userid", equalTo: PFUser.current()!.objectId!)
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

    
    func onClickCameraButton(_ button: UIButton){
        
        
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            vc.sourceType = .photoLibrary
        }
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        
        let imageData = UIImageJPEGRepresentation(originalImage, 1.0)
        
        let imageName = UUID().uuidString
        let extensionString: String = ".jpg"
        
        
        
        let imageFile = PFFile(name:imageName + extensionString, data:imageData!)
        
        
        
        var fashionPhoto = PFObject(className:"photos")
        fashionPhoto["image_id"] = UUID().uuidString
        fashionPhoto["uploadedBy_userid"] = self.currentUser?.userObjectId
        fashionPhoto["personal_image"] = imageFile
        fashionPhoto.saveInBackground()
        
        
        // Dismiss UIImagePickerController to go back to your original view controller
        
        dismiss(animated: true) {
            //self.performSegue(withIdentifier: "HotFashionsViewController", sender: nil)
            
            
        }
        
    }

}
