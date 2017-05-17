//
//  MatchCell.swift
//  LoveAndHiphop
//
//  Created by Mogulla, Naveen on 5/9/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import SwiftyGif
import Parse

//@objc protocol MatchCellDelegate {
//  @objc optional func MatchCell(matchCell: MatchCell, onLikeClicked: Bool)
//  @objc optional func MatchCell(matchCell: MatchCell, onCancelClicked: Bool)
//}

@objc protocol MatchCellDelegate {
  func MatchCell(matchCell: MatchCell, didLikeUser value: Bool)
  func MatchCellCancelled(matchCell: MatchCell, didCancelUser value: Bool)
}

class MatchCell: UITableViewCell {
    

    @IBOutlet weak var profilePicImageView: UIImageView!
    
    @IBOutlet weak var lovemenotImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hiphopIdentityLabel: UILabel!
  @IBOutlet weak var cancelUserButton: UIButton!
  @IBOutlet weak var likeUserButton: UIButton!

    weak var delegate: MatchCellDelegate?

    var userObject: UserObject! {
        didSet{
            profilePicImageView.setImageWith(userObject.profileImageUrl!)
            locationLabel.text = userObject.city
            occupationLabel.text = userObject.occupation
            hiphopIdentityLabel.text = userObject.hiphopIdentity
            nameLabel.text = userObject.fullName
          
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//      onSwitch.addTarget(self, action: #selector(SwitchCell.switchValueChanged), for: UIControlEvents.valueChanged)
//      let cancelUserTap = UITapGestureRecognizer(target: self, action: #selector(onTapCancel(_:)))
//      let likeUserTap = UITapGestureRecognizer(target: self, action: #selector(onTapLike(_:)))
      
//      originalTweeterImageView.addGestureRecognizer(profileTap)
//      originalTweeterImageView.isUserInteractionEnabled = true
      likeUserButton.addTarget(self, action: #selector(MatchCell.userLiked), for: UIControlEvents.touchUpInside)
      cancelUserButton.addTarget(self, action: #selector(MatchCell.userCancelled), for: UIControlEvents.touchUpInside)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func userLiked() {
    print("liked@")
    delegate?.MatchCell(matchCell: self, didLikeUser: true)
  }
  
  func userCancelled() {
    print("liked@")
    delegate?.MatchCellCancelled(matchCell: self, didCancelUser: true)
  }

    
}
