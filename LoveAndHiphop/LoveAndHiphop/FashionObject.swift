//
//  FashionObject.swift
//  LoveAndHiphop
//
//  Created by Mogulla, Naveen on 4/29/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import Parse

class FashionObject: PFObject, PFSubclassing {
    
    var imageId: String?
    var userId: String?
    var likesCount: Int?
    var likeCount: Int?
    var liked_users: [String]?
    var imageFile: PFFile?
    var imagUrl: URL?
    var userName: String?
    var alreadyLiked: Bool = false
    
    init(pfObject: PFObject){
        imageId = pfObject["image_id"] as? String
        userId = pfObject["uploadedBy_userid"] as? String
        userName = pfObject["uploadedBy_user"] as? String
        likeCount = pfObject["likes_count"] as? Int
        imageFile = pfObject["fashion_image"] as? PFFile
        liked_users = pfObject["liked_users"] as? [String]
        likesCount = liked_users?.count ?? 0
        if (liked_users?.contains((PFUser.current()?.objectId)!) == true){
            alreadyLiked = true
        }
        
        let imageFileURL: String = imageFile!.url!
        imagUrl = URL(string: imageFileURL)
        super.init()
    }
    
    
    public class func parseClassName() -> String {
        return "FashionObject"
    }
    
    class func fashionObjectWithArray(pfObjects: [PFObject]) -> [FashionObject] {
        var fashionObjects = [FashionObject]()
        
        for pfObject in pfObjects {
            let fashionObject = FashionObject(pfObject: pfObject)
            fashionObjects.append(fashionObject)
        }
        return fashionObjects
    }
}
