//
//  Notification.swift
//  Connectivity
//
//  Created by Danial Zahid on 15/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class NotificationModel: BaseEntity {

    var full_name: String?
    var title: String?
    var image_path: String?
    
    override init() {
        super.init()
    }
    
    override init(dictionary: [AnyHashable : Any]!) {
        super.init()
        self.setValuesForKeysWithJSONDictionary(dictionary, dateFormatter: nil)
    }

    
}
