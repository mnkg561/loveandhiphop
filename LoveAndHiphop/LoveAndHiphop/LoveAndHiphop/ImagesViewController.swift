//
//  ImagesViewController.swift
//  LoveAndHiphop
//
//  Created by Mogulla, Naveen on 5/2/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit

class ImagesViewController: UIViewController {



    @IBOutlet weak var topImageView: UIImageView!

    @IBOutlet weak var bottomImageView: UIImageView!
    
    var fashionObjects: [FashionObject]?
    var indexPath: IndexPath?
    var index: Int?
    
    var testUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        index = indexPath!.row
        
        let topPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onPanGestureImages))
        topImageView.addGestureRecognizer(topPanGesture)
        
        let bottomPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onPanGestureImages))
        
        bottomImageView.addGestureRecognizer(bottomPanGesture)
        
        loadImages(index: index!, imageView: topImageView)
      
        
        // Do any additional setup after loading the view.
    }
    
    func loadImages(index: Int, imageView: UIImageView){
        let fashionObject: FashionObject = (self.fashionObjects?[index])!
        imageView.setImageWith(fashionObject.imagUrl!)
        

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    
    
   
    
    func onPanGestureImages(sender: UIPanGestureRecognizer) {
        
        let point = sender.location(in: view)
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        let pannedImage = sender.view as! UIImageView
        var otherImage: UIImageView?
        
        if pannedImage == topImageView {
            otherImage = self.bottomImageView
        } else if pannedImage == bottomImageView{
            otherImage = self.topImageView
        }
        
        
        if sender.state == .began{
            
        }else if sender.state == .changed {
            
            if (translation.x > 0){
                print("i'm movinng right side")
                pannedImage.center = CGPoint(x: point.x + translation.x, y: pannedImage.center.y)
            } else if (translation.x < 0 ){
                print("i'm moving left side")
               UIView.animate(withDuration: 0.5, animations: {
             pannedImage.center = CGPoint(x: point.x + translation.x, y: pannedImage.center.y)
               })
               
                
            } else if (translation.y < 0){
                print("i'm moving upside")
            } else if (translation.y > 0 ){
                print("i'm moving downside")
            }
            
            
        }else if sender.state == .ended {
            
            if (velocity.x < 0) {
                print("loading the image for left side")
                loadImages(index: index!+1, imageView: otherImage!)
                self.index = self.index!+1
            } else if (velocity.x > 0) {
                self.index = self.index!-1
                loadImages(index: index!-1, imageView: otherImage!)
            }
        }
    }
    
    
    /*
     @IBOutlet var onPanGestureTopImage: UIPanGestureRecognizer!
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
