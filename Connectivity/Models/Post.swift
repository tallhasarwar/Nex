//
//  Post.swift
//  Connectivity
//
//  Created by Danial Zahid on 03/01/2018.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit

class Post: BaseEntity {

    var content: String?
    var location_id: String?
    var location_name: String?
    var latitude: String?
    var longitude: String?
    var image_path: String?
    var created_at: NSDate?
    var full_name: String?
    var id: String?
    var user_id: String?
    var user_image: String?
    
    override init() {
        super.init()
    }
    
    override init(dictionary: [AnyHashable : Any]!) {
        super.init()
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = Constant.serverDateFormat
        newDateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        self.setValuesForKeysWithJSONDictionary(dictionary, dateFormatter: newDateFormatter)
    }
    
}
