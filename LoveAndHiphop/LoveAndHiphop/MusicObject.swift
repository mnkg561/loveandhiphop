//
//  MusicObject.swift
//  LoveAndHiphop
//
//  Created by Mogulla, Naveen on 4/27/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import Parse

class MusicObject: PFObject, PFSubclassing {
    var songName: String?
    var songId: String?
    var songOrder: Int?
    var songUrl: URL?
    var songFile: PFFile?
    
    init(pfObject: PFObject) {
        songName = pfObject["song_name"] as? String
        songId = pfObject["song_id"] as? String
        songOrder = pfObject["top_song_order"] as? Int
        songFile = pfObject["song_file"] as? PFFile
        let audioFileURL: String = songFile!.url!
        songUrl = URL(string: audioFileURL)
        super.init()
    }
    
    public class func parseClassName() -> String {
        return "MusicObject"
    }
    
    class func musicObjectWithArray(pfObjects: [PFObject]) -> [MusicObject] {
        var musicObjects = [MusicObject]()
        
        for pfObject in pfObjects {
            let musicObject = MusicObject(pfObject: pfObject)
            musicObjects.append(musicObject)
        }
        return musicObjects
    }
}
