//
//  User.swift
//  Connectivity
//
//  Created by Danial Zahid on 24/09/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit
import Firebase

class User: BaseEntity {
    
    var full_name: String?
    var email: String?
    var user_id: String?
//    var image_path: String?
    var about: String?
    var interests: String?
    var school: String?
    var worked_at: String?
    var works_at: String?
    var lives_in: String?
    var contact_number: String?
    var facebook_profile: String?
    var linkedin_profile: String?
    var website: String?
    var google_profile: String?
    var headline: String?
    var tagline: String?
    var checkin_time: NSDate?
    var event_checkin_time: NSDate?
    var unread_notification_count: Int?
    var profileImages = Images()
    
    override init() {
        super.init()
    }
    
    override init(dictionary: [AnyHashable : Any]!) {
        super.init()
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = Constant.serverDateFormat
        newDateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        self.setValuesForKeysWithJSONDictionary(dictionary, dateFormatter: newDateFormatter)
        self.unread_notification_count = Int(dictionary["unread_notification_count"] as? String ?? "0")
        if let profileImages = dictionary["profile_images"] as? [String: AnyObject] {
            self.profileImages = Images(dictionary: profileImages)
        }
    }
    
    
}
