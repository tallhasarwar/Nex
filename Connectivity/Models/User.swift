
//
//  User.swift
//  Connectivity
//
//  Created by Danial Zahid on 24/09/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit
import Firebase

@objc class User: BaseEntity {
    
    @objc var full_name: String?
    @objc var email: String?
    @objc var user_id: String?
//    var image_path: String?
    @objc var about: String?
    @objc var interests: String?
    @objc var school: String?
    @objc var worked_at: String?
    @objc var works_at: String?
    @objc var lives_in: String?
    @objc var contact_number: String?
    @objc var facebook_profile: String?
    @objc var linkedin_profile: String?
    @objc var website: String?
    @objc var google_profile: String?
    @objc var headline: String?
    @objc var tagline: String?
    @objc var checkin_time: NSDate?
    @objc var event_checkin_time: NSDate?
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
        if let profileImages = dictionary["images"] as? [String: AnyObject] {
            self.profileImages = Images(dictionary: profileImages)
        }
        if let profileImages = dictionary["profile_images"] as? [String: AnyObject] {
            self.profileImages = Images(dictionary: profileImages)
        }
        if let name = dictionary["name"] as? String {
            self.full_name = name
        }
    }
    
    
}
