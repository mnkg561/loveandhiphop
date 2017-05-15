//
//  MatchCell.swift
//  LoveAndHiphop
//
//  Created by Mogulla, Naveen on 5/9/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import SwiftyGif

protocol MatchCellDelegate: class {
    func onLikeClicked (user: UserObject)
    func onCancelClicked (cancelledUserObject: UserObject)

}

class MatchCell: UITableViewCell {
    

    @IBOutlet weak var profilePicImageView: UIImageView!
    
    @IBOutlet weak var lovemenotImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hiphopIdentityLabel: UILabel!

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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func onClickLikeButton(_ sender: UIButton) {
        print("somebody clicked like/unlike in cell")
        delegate?.onLikeClicked(user: userObject)

    }

    @IBAction func onClickCancelButton(_ sender: UIButton) {
        print("somebody clicked cancel in cell")
        delegate?.onCancelClicked(cancelledUserObject: userObject)
    }

    
}
