//
//  UserObject.swift
//  LoveAndHiphop
//
//  Created by Mogulla, Naveen on 5/9/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import Parse

class UserObject: PFObject, PFSubclassing {
    
    var firstName: String?
    var lastName: String?
    var age: Int?
    var gender: String?
    var occupation: String?
    var email: String?
    var about: String?
    var intrestedIn: String?
    var hiphopIdentity: String?
    var height: Int?
    var weight: Int?
    var city: String?
    var state: String?
    var country: String?
    var otherInterests: String?
    var profileImageFile: PFFile?
    var profileImageUrl: URL?
    var fullName: String?
    var userObjectId: String?
    var location: String?
    var space: String = " "
    
    
    
    init(pfObject: PFObject) {
        userObjectId = pfObject.objectId
        firstName = pfObject["firstName"] as? String
        lastName = pfObject["lastName"] as? String
        fullName = firstName!+space+lastName!
        //age = pfObject["age"] as? Int
        gender = pfObject["gender"] as? String
        occupation = pfObject["occupation"] as? String
        email = pfObject["email"] as? String
        about = pfObject["about"] as? String
        intrestedIn = pfObject["genderPreference"] as? String
        hiphopIdentity = pfObject["hiphopIdentity"] as? String
        //height = pfObject["height"] as? Int
       // weight = pfObject["weight"] as? Int
        city = pfObject["city"] as? String
        state = pfObject["state"] as? String
        
        if city != nil
        {
            if state != nil {
                location = city! + ", " + state!
            }
 
        }
        country = pfObject["country"] as? String
        otherInterests = pfObject["otherInterests"] as? String
        profileImageFile = pfObject["profilePicImage"] as? PFFile
        let profileImageFileURL: String = profileImageFile!.url!
        profileImageUrl = URL(string: profileImageFileURL)
        super.init()
    }
    
    class func userObjectWithArray(pfObjects: [PFObject]) -> [UserObject] {
        var userObjects = [UserObject]()
        
        for pfObject in pfObjects {
            let userObject = UserObject(pfObject: pfObject)
            userObjects.append(userObject)
        }
        return userObjects
    }
  
    public class func parseClassName() -> String {
        return "UserObject"
    }
    
    class func currentUser(pfObject: PFObject) -> UserObject {
        
        return UserObject(pfObject: pfObject)
    }
    
}
