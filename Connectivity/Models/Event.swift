//
//  Event.swift
//  Connectivity
//
//  Created by Danial Zahid on 02/11/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class Event: BaseEntity {

    var name: String?
    var location: String?
    var raduis: String?
    var start_date: NSDate?
    var end_date: NSDate?
    var user_id: String?
    var status: String?
    var image_path: String?
    var created_at: NSDate?
    var id: String?
    var latitude: String?
    var longitude: String?
    
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
