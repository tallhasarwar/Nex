//
//  ProfileDetail.swift
//  Connectivity
//
//  Created by Danial Zahid on 24/09/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

@objc class ProfileDetail: BaseEntity {

    @objc var title : String?
    @objc var detailDescription: String?
    
    convenience init(title: String, description: String) {
        self.init()
        self.title = title
        self.detailDescription = description
        
    }
}
