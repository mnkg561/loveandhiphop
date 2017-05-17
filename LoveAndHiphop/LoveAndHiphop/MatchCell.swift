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
  @IBOutlet weak var youLikedLabel: UILabel!
  
  weak var delegate: MatchCellDelegate?
  
  var likedByCurrentUser: Bool? {
    didSet {
      youLikedLabel.isHidden = likedByCurrentUser!
    }
  }
  
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
    
    likeUserButton.addTarget(self, action: #selector(MatchCell.userLiked), for: UIControlEvents.touchUpInside)
    cancelUserButton.addTarget(self, action: #selector(MatchCell.userCancelled), for: UIControlEvents.touchUpInside)
    
    // Display if current user has liked this user.
    youLikedLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 3)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func userLiked() {
    delegate?.MatchCell(matchCell: self, didLikeUser: true)
  }
  
  func userCancelled() {
    delegate?.MatchCellCancelled(matchCell: self, didCancelUser: true)
  }
  
  
}
