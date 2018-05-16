//
//  Notification.swift
//  Connectivity
//
//  Created by Danial Zahid on 15/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

@objc class NotificationModel: BaseEntity {

    @objc var full_name: String?
    @objc var title: String?
    @objc var image_path: String?
    @objc var created_at: NSDate?
    @objc var component_id: String?
    @objc var id: String?
    
    override init() {
        super.init()
    }
    
    override init(dictionary: [AnyHashable : Any]!) {
        super.init()
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = Constant.serverDateFormat
        newDateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        self.setValuesForKeysWithJSONDictionary(dictionary, dateFormatter: newDateFormatter)
//        self.id = dictionary["id"] as? String
    }

    
}
