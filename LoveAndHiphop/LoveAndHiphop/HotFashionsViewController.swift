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

class HotFashionsViewController: UIViewController,  UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var fashionObjects: [FashionObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
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
        
        let likesCount = (self.fashionObjects?[indexPath.row].likesCount)!
        let fullString = String(describing: likesCount) + " likes"
        cell.likesLabel.text = fullString
        cell.likeButton.isUserInteractionEnabled = false
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
