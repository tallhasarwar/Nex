//
//  Event.swift
//  Connectivity
//
//  Created by Danial Zahid on 02/11/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

@objc class Event: BaseEntity {

    @objc var name: String?
    @objc var location: String?
    @objc var raduis: String?
    @objc var start_date: NSDate?
    @objc var end_date: NSDate?
    @objc var user_id: String?
    @objc var status: String?
    @objc var distance: String?
    @objc var eventImages = Images()
    @objc var organizerModel = User()
    @objc var created_at: NSDate?
    @objc var id: String?
    @objc var latitude: String?
    @objc var longitude: String?
    @objc var descriptionValue: String?
    
    override init() {
        super.init()
    }
    
    override init(dictionary: [AnyHashable : Any]!) {
        super.init()
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = Constant.serverDateFormat
        newDateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        self.setValuesForKeysWithJSONDictionary(dictionary, dateFormatter: newDateFormatter)
        self.descriptionValue = dictionary["description"] as? String ?? ""
        if let profileImages = dictionary["event_images"] as? [String: AnyObject] {
            self.eventImages = Images(dictionary: profileImages)
        }
        if let organizer = dictionary["organizer"] as? [String: AnyObject] {
            self.organizerModel = User(dictionary: organizer)
        }
    }
    
}
