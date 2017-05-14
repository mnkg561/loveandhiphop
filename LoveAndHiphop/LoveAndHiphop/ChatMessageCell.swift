//
//  ChatMessageCell.swift
//  LoveAndHiphop
//
//  Created by hollywoodno on 5/2/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import Parse

class ChatMessageCell: UITableViewCell {
  
  // MARK: Properties
  @IBOutlet weak var chatMessageText: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var messageOwnerImageView: UIImageView!
  @IBOutlet weak var cellContentView: UIView!
  
  
  var message: PFObject! {
    didSet {
      chatMessageText.text = message["text"] as? String
      let postingUser = message["createdBy"] as! PFUser
      nameLabel.text = postingUser["firstName"] as? String
      
      // Load profile image
      if let postingUserProfileImage = postingUser["profilePicImage"] as? PFFile {
        postingUserProfileImage.getDataInBackground(block: { (data: Data?, error: Error?) in
          if (error == nil) {
            self.messageOwnerImageView.image = UIImage(data: data!)
          }
        }) // End of query block for profile image
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    chatMessageText.sizeToFit()
    chatMessageText.layoutIfNeeded()
    chatMessageText.layer.cornerRadius = 15
    
    messageOwnerImageView.image = #imageLiteral(resourceName: "Selfie-50")
    messageOwnerImageView.layer.cornerRadius = 20
    
    contentView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
    contentView.layer.borderWidth = 7
    contentView.layer.cornerRadius = 15
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
