//
//  TopListenerCell.swift
//  LoveAndHiphop
//
//  Created by Mogulla, Naveen on 4/28/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit

class TopListenerCell: UITableViewCell {
    
    
    @IBOutlet weak var userNameLabel: UILabel!

    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
