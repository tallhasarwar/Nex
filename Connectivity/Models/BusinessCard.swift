//
//  BusinessCard.swift
//  Connectivity
//
//  Created by Danial Zahid on 17/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

@objc class BusinessCard: BaseEntity {

    @objc var id: String?
    @objc var user_id: String?
    @objc var name: String?
    @objc var title: String?
    @objc var email: String?
    @objc var phone: String?
    @objc var address: String?
    @objc var web: String?
//    var image: String?
    @objc var profileImages = Images()
    
    override init() {
        super.init()
    }
    
    override init(dictionary: [AnyHashable : Any]!) {
        super.init()
        self.setValuesForKeysWithJSONDictionary(dictionary, dateFormatter: nil)
        if let profileImages = dictionary["card_images"] as? [String: AnyObject] {
            self.profileImages = Images(dictionary: profileImages)
        }
    }
}
