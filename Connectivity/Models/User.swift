//
//  User.swift
//  Connectivity
//
//  Created by Danial Zahid on 24/09/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class User: BaseEntity {
    
    var full_name: String?
    var email: String?
    var user_id: String?
    var image_path: String?
    var about: String?
    var interests: String?
    var school: String?
    var worked_at: String?
    var lives_in: String?
    var contact_number: String?
    var facebook_profile: String?
    var linkedin_profile: String?
    var website: String?
    var google_profile: String?
    var headline: String?
    
    override init() {
        super.init()
    }
    
    override init(dictionary: [AnyHashable : Any]!) {
        super.init()
        self.setValuesForKeysWithJSONDictionary(dictionary, dateFormatter: nil)
    }
    
    func linkedInLoginDictionary() -> [String: AnyObject]{
        var paramDict = [String: AnyObject]()
        
        
//        paramDict["emailAddress"] = emailAddress
//        paramDict["firstName"] = firstName
//        paramDict["lastName"] = lastName
//        paramDict["headline"] = headline
//        paramDict["pictureUrl"] = pictureUrl
//        paramDict["id"] = id
//        paramDict["publicProfileUrl"] = publicProfileUrl
        
        return paramDict
    }
    
}
