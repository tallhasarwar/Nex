//
//  BusinessCard.swift
//  Connectivity
//
//  Created by Danial Zahid on 17/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class BusinessCard: BaseEntity {

    var id: String?
    var user_id: String?
    var name: String?
    var title: String?
    var email: String?
    var phone: String?
    var address: String?
    var web: String?
    var image: String?
    
    override init() {
        super.init()
    }
    
    override init(dictionary: [AnyHashable : Any]!) {
        super.init()
        self.setValuesForKeysWithJSONDictionary(dictionary, dateFormatter: nil)
    }
}
