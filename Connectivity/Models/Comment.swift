//
//  Comment.swift
//  Connectivity
//
//  Created by Danial Zahid on 6/9/18.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit

class Comment: BaseEntity {

    
    @objc var comment: String?
    @objc var created_at: NSDate?
    @objc var full_name: String?
    @objc var headline: String?
    @objc var id: String?
    @objc var number_of_likes: String?
    @objc var post_id: String?
    @objc var user_id: String?
    var isSelfLiked: Bool?
    
    var profileImages = Images()
    @objc var optionsPopover: Popover!
    
    override init() {
        super.init()
    }
    
    
    override init(dictionary: [AnyHashable : Any]!) {
        super.init()
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = Constant.serverDateFormat
        newDateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        self.setValuesForKeysWithJSONDictionary(dictionary, dateFormatter: newDateFormatter)
        
        if let profileImages = dictionary["profile_images"] as? [String: AnyObject] {
            self.profileImages = Images(dictionary: profileImages)
        }
        
        if let isLiked = dictionary["comment_action"] as? String {
            if isLiked == "like" {
                self.isSelfLiked = true
            }
            else {
                self.isSelfLiked = false
            }
        }
        else {
            self.isSelfLiked = false
        }
        
    }
    
    
}
