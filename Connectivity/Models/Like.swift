//
//  Like.swift
//  Connectivity
//
//  Created by Tallha Sarwar on 19/06/2018.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import Foundation
//
//  Comment.swift
//  Connectivity
//
//  Created by Danial Zahid on 6/9/18.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit

class Like: BaseEntity {
    
    
    
    @objc var created_at: NSDate?
    @objc var full_name: String?
    @objc var headline: String?
    @objc var id: String?
    @objc var post_id: String?
    @objc var user_id: String?
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
        
        if let profileImages = dictionary["profile_images"] as? [String: AnyObject] {
            self.profileImages = Images(dictionary: profileImages)
        }
        
        
        
    }
    
    
}
