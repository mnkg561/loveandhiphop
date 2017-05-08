//
//  MatchCellTableViewCell.swift
//  LoveAndHiphop
//
//  Created by Mogulla, Naveen on 5/3/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit

class MatchCell: UITableViewCell {
    
    
    @IBOutlet weak var matchProfilePic: UIImageView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var registeredAsLabel: UILabel!
    
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var topInterestLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
