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

class HotFashionsViewController: UIViewController,  UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var fashionObjects: [FashionObject]?
    
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
        
       
        
        var fashionPhoto = PFObject(className:"hotFashions")
        fashionPhoto["image_id"] = UUID().uuidString
        fashionPhoto["uploadedBy_userid"] = "naveen"
        fashionPhoto["likes_count"] = 0
        fashionPhoto["fashion_image"] = imageFile
        fashionPhoto.saveInBackground()
        
        
        // Dismiss UIImagePickerController to go back to your original view controller
        
        dismiss(animated: true) {
            //self.performSegue(withIdentifier: "HotFashionsViewController", sender: nil)
            
            
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapOwnerImage(tapGesture:)))
        cell.fashionImage.isUserInteractionEnabled = true
        cell.fashionImage.addGestureRecognizer(tapGesture)

        cell.fashionImage.setImageWith((self.fashionObjects?[indexPath.row].imagUrl)!)
        
        //let likesCount = (self.fashionObjects?[indexPath.row].likesCount)!
        let likedCount = (self.fashionObjects?[indexPath.row].liked_users?.count) ?? 0
        
        
        cell.likeButton.setImage(UIImage(named: "Like Filled-50"), for: UIControlState.normal)
        let fullString = String(describing: likedCount) + " likes"
        cell.likesLabel.text = fullString
        cell.likeButton.isUserInteractionEnabled = true
        //cell.fashionImage.image = UIImage(named: "Date Man Woman Filled-50")
        return cell
    }


    
    func onTapOwnerImage(tapGesture: UITapGestureRecognizer){
         print("i'm tapped")
        let tapLocation = tapGesture.location(in: self.collectionView)
        let indexPath =  self.collectionView.indexPathForItem(at: tapLocation)
        
        let fashionObject: FashionObject = (self.fashionObjects?[indexPath!.row])!
        
        print("print me \(fashionObject.imagUrl!)")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let ImagesViewController = storyBoard.instantiateViewController(withIdentifier: "ImagesViewController") as! ImagesViewController
        
            let imageUrl: URL = fashionObject.imagUrl!
            ImagesViewController.testUrl = imageUrl
            ImagesViewController.fashionObjects = self.fashionObjects
            ImagesViewController.indexPath = indexPath
       
        
        
        self.present(ImagesViewController, animated:true, completion:nil)

    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var indexPath: IndexPath!
         print("I'm inside prepare method")
        let imagePressed = sender as! FashionCell
        indexPath = collectionView.indexPath(for: imagePressed)
        
    
        let DetailImageViewController = segue.destination as! UIViewController
        
    
        
        
       
        
    }
 */
}
