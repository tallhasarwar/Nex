//
//  Image.swift
//  Connectivity
//
//  Created by Danial Zahid on 1/30/18.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit

class Images: BaseEntity {
    
    var medium = Image()
    var small = Image()
    var original = Image()
    
    override init() {
        super.init()
    }
    
    override init(dictionary: [AnyHashable : Any]!) {
        super.init()
//        self.setValuesForKeysWithJSONDictionary(dictionary, dateFormatter: nil)
        
        if let med = dictionary["meduim"] as? [String: AnyObject] {
            self.medium = Image(dictionary: med)
        }
        if let orig = dictionary["orignal"] as? [String: AnyObject] {
            self.original = Image(dictionary: orig)
        }
        if let sma = dictionary["small"] as? [String: AnyObject] {
            self.small = Image(dictionary: sma)
        }
        
    }
}


class Image: BaseEntity {
    
    var aspect: Float?
    var height: CGFloat?
    var maxWidth: CGFloat?
    var suffix: String?
    var url: String = ""
    var width: CGFloat?
    
    override init() {
        super.init()
    }
    
    override init(dictionary: [AnyHashable : Any]!) {
        super.init()
//        self.setValuesForKeysWithJSONDictionary(dictionary, dateFormatter: nil)
        aspect = Float(dictionary["aspect"] as? String ?? "1.0")
        height = dictionary["height"] as? CGFloat ?? 1.0
        maxWidth = dictionary["maxWidth"] as? CGFloat ?? 1.0
        width = dictionary["width"] as? CGFloat ?? 1.0
        url = dictionary["url"] as? String ?? ""
        suffix = dictionary["suffix"] as? String ?? ""
        
        
    }
}
