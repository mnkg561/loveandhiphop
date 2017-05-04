//
//  FashionCellCollectionViewCell.swift
//  LoveAndHiphop
//
//  Created by Mogulla, Naveen on 4/28/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit

class FashionCell: UICollectionViewCell {
    
    @IBOutlet weak var fashionImage: UIImageView!

    
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    
    @IBAction func onClickLikeButton(_ sender: UIButton) {
        print("User like button tapped")
        //sender.isUserInteractionEnabled = false
    }
 
    
}
