//
//  SongCell.swift
//  LoveAndHiphop
//
//  Created by Mogulla, Naveen on 4/25/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import AVFoundation

class SongCell: UITableViewCell {
    


    @IBOutlet weak var songName: UILabel!
    var songUrl: URL?
    
    var musicObject: MusicObject! {
        didSet{
            songName.text = musicObject.songName
            songUrl = musicObject.songUrl
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

}
