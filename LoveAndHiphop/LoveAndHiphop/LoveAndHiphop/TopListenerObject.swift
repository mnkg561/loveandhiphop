//
//  TopListenerObject.swift
//  LoveAndHiphop
//
//  Created by Mogulla, Naveen on 4/28/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import Parse

class TopListenerObject: PFObject, PFSubclassing {
    
    var userId: String?
    var playedCount: Int?
    
    init(pfObject: PFObject){
        userId = pfObject["userId"] as? String
        playedCount = pfObject["played_count"] as? Int
        super.init()
    }
    
    public class func parseClassName() -> String {
        return "TopListenerObject"
    }
    
    class func listenerObjectsWithArray(pfObjects: [PFObject]) -> [TopListenerObject]{
        
        var topListenerObjects = [TopListenerObject]()
        
        for pfObject in pfObjects {
            let listenerObject = TopListenerObject(pfObject: pfObject)
            topListenerObjects.append(listenerObject)

        }
        
        return topListenerObjects
        
    }
    

}
