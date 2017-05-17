//
//  HotFashionsViewController.swift
//  LoveAndHiphop
//
//  Created by Mogulla, Naveen on 4/25/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import Parse
import AFNetworking
import Canvas

class HotFashionsViewController: UIViewController,  UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    @IBOutlet weak var animationView: CSAnimationView!
    @IBOutlet weak var centralImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var likedCount: Int?
    
    var fashionObjects: [FashionObject]?
    var fashhionObject: FashionObject?
    var fashionByUser: UserObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for:UIControlEvents.valueChanged)
        
        collectionView.insertSubview(refreshControl, at: 0)
        collectionView.alwaysBounceVertical = true
        loadHotFashions()
        
        

        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "camera"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(self.onClickCameraButton(_:)), for: .touchDown)
        let item1 = UIBarButtonItem(customView: btn1)
    
        self.navigationItem.setRightBarButton(item1, animated: true)
        
       
    }
    
    func loadHotFashions(){
        let query = PFQuery(className: "hotFashions")
        query.addDescendingOrder("likes_count")
        
        query.findObjectsInBackground { (fashionObjects: [PFObject]?, error: Error?) in
            if error == nil {
                let fashionObjects2 = FashionObject.fashionObjectWithArray(pfObjects: fashionObjects!)
                self.fashionObjects = fashionObjects2
                self.collectionView.reloadData()
                self.loadCentralView(index: 0)
            }
        }
        

    }
    
    func refreshData() {
        let query = PFQuery(className: "hotFashions")
        query.addDescendingOrder("likes_count")
        
        query.findObjectsInBackground { (fashionObjects: [PFObject]?, error: Error?) in
            if error == nil {
                let fashionObjects2 = FashionObject.fashionObjectWithArray(pfObjects: fashionObjects!)
                self.fashionObjects = fashionObjects2
                self.collectionView.reloadData()
                
            }
        }

    }
    
    func refreshControlAction (refreshControl: UIRefreshControl){
        refreshControl.tintColor = .blue
        loadHotFashions()
        
        refreshControl.endRefreshing()
        
    }
    
    func onClickCameraButton(_ button: UIButton){
        
        
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
        //let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        
        let imageData = UIImageJPEGRepresentation(originalImage, 1.0)
        
        let imageName = UUID().uuidString
        let extensionString: String = ".jpg"
        
       
        
        let imageFile = PFFile(name:imageName + extensionString, data:imageData!)
        
        let query: PFQuery = PFUser.query()!
        query.whereKey("objectId", equalTo: PFUser.current()!.objectId!)
        
        query.getFirstObjectInBackground { (currentUser: PFObject?, error: Error?) in
            if error == nil {
                let currentUser2: UserObject = UserObject.currentUser(pfObject: currentUser!)
                
        
        let fashionPhoto = PFObject(className:"hotFashions")
        fashionPhoto["image_id"] = UUID().uuidString
        fashionPhoto["uploadedBy_userid"] = PFUser.current()?.objectId
        fashionPhoto["likes_count"] = 0
        fashionPhoto["fashion_image"] = imageFile
        fashionPhoto["uploadedBy_user"] = currentUser2.firstName
        fashionPhoto["liked_users"] = []
        fashionPhoto.saveInBackground()
        
            }
        }
        
        // Dismiss UIImagePickerController to go back to your original view controller
        
        dismiss(animated: true) {
            //self.performSegue(withIdentifier: "HotFashionsViewController", sender: nil)
            
            self.loadHotFashions()
        }

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.fashionObjects != nil {
            return (self.fashionObjects?.count)!
        } else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
        "FashionCell", for: indexPath) as! FashionCell
        
       
        cell.fashionImage.setImageWith((self.fashionObjects?[indexPath.row].imagUrl)!)
        
        //let likesCount = (self.fashionObjects?[indexPath.row].likesCount)!
//        let likedCount = (self.fashionObjects?[indexPath.row].liked_users?.count) ?? 0
//        
//
//        cell.likeButton.setImage(UIImage(named: "Like Filled-50"), for: UIControlState.normal)
//        let fullString = String(describing: likedCount) + " likes"
//        cell.likesLabel.text = fullString
//        cell.likeButton.isUserInteractionEnabled = true
//        //cell.fashionImage.image = UIImage(named: "Date Man Woman Filled-50")
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("index path is \(indexPath.row)")
       
        loadCentralView(index: indexPath.row)
    }
    
    
    func loadCentralView(index: Int){
         self.fashhionObject = self.fashionObjects?[index]
        centralImageView.setImageWith((self.fashhionObject?.imagUrl!)!)
        nameLabel.text = self.fashhionObject?.userName
         let likedCount = self.fashhionObject?.likesCount
            likesLabel.text = String(likedCount!)
        if self.fashhionObject?.alreadyLiked == true {
            likeImage.image = UIImage(named: "Like Filled-50")
            likeImage.isUserInteractionEnabled = false
            
        } else {
        likeImage.image = UIImage(named: "Like-50")
        likeImage.isUserInteractionEnabled = true
        }
//        
        loadImageUploaded(userObjectId: (self.fashhionObject?.userId!)!, success: { (userObject: UserObject) in
            self.fashionByUser = userObject
        }) { 
            print("something wrong")
        }
        
        animationView.startCanvasAnimation()

        
    }
    

    @IBAction func onTapLIkeButton(_ sender: UITapGestureRecognizer) {

        likesLabel.text = String((self.fashhionObject?.likesCount!)! + 1)
        likeImage.image = UIImage(named: "Like Filled-50")
        likeImage.isUserInteractionEnabled = false
        
        let query = PFQuery(className: "hotFashions")
        query.whereKey("image_id", equalTo: self.fashhionObject?.imageId)
        
        query.getFirstObjectInBackground { (pfObject: PFObject?, error: Error?) in
            if (error == nil) {
                var liked_users: [String] = (self.fashhionObject?.liked_users)!
                liked_users.append((PFUser.current()?.objectId!)!)
                pfObject?["liked_users"] = liked_users
                pfObject?["likes_count"] = (self.fashhionObject?.likeCount)! + 1
                pfObject?.saveInBackground()
                self.refreshData()
            }
        }

        
    }
    
    func loadImageUploaded(userObjectId: String, success: @escaping (UserObject) -> (), failure: @escaping () -> ()){
        //let topListenerObject: TopListenerObject = (self.topListenerObjects?[indexPath.row])!
        let query: PFQuery = PFUser.query()!
        query.whereKey("objectId", equalTo: userObjectId)
        
        query.getFirstObjectInBackground { (targetUser: PFObject?, error: Error?) in
            if error == nil {
                print("i got something")
                let targetUser: UserObject = UserObject.currentUser(pfObject: targetUser!)
                print("i think so")
                success(targetUser)
                print("i'm fully exected")
            } else {
                print("error")
            }
            
        }
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print(" Yea me too")
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.userObject = self.fashionByUser
        
        
    }
    
  

}
