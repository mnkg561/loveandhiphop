//
//  ImagesViewController.swift
//  LoveAndHiphop
//
//  Created by Mogulla, Naveen on 5/2/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import AFNetworking

class ImagesViewController: UIViewController, UIScrollViewDelegate {



    @IBOutlet weak var mainScrollView: UIScrollView!
    
    //var imageView: UIImageView!
    
    var fashionObjects: [FashionObject]?
    var indexPath: IndexPath?
    var index: Int?
    
    
    var testUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        index = indexPath!.row
        mainScrollView.delegate = self
        mainScrollView.frame = view.frame
        mainScrollView.maximumZoomScale = 5.0
        mainScrollView.minimumZoomScale = 0.5
        
        index = indexPath!.row
  
        for i in 0..<self.fashionObjects!.count {
            let imageView = UIImageView()
            imageView.setImageWith((self.fashionObjects?[i].imagUrl!)!)
            imageView.contentMode = .scaleAspectFit
            let xPosition = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: self.mainScrollView.frame.width, height: self.mainScrollView.frame.height)
            mainScrollView.contentSize.width = mainScrollView.frame.width * CGFloat(i+1)
            mainScrollView.addSubview(imageView)
            print("added")
        }
        let presentPosition = self.view.frame.width * CGFloat(index!)
        mainScrollView.setContentOffset(CGPoint(x: presentPosition, y: 0), animated: true)
        
      
    }
    /*
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
        
    }
    
    */
   
    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func clickOnCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true) { 
            print("Image View is being dismissed")
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
