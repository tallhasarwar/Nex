//
//  GooglePlace.swift
//  Connectivity
//
//  Created by Danial Zahid on 09/11/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

@objc class GooglePlace: BaseEntity {

    @objc var place_id: String?
    @objc var vicinity: String?
    @objc var name: String?
    var rating: Int?
    @objc var imageReference: String?
    var coordinates: CLLocationCoordinate2D?
    var openNow: Bool?

    
    override init() {
        super.init()
    }
    
    override init(dictionary: [AnyHashable : Any]!) {
        super.init()
        
        self.setValuesForKeysWithJSONDictionary(dictionary, dateFormatter: nil)
        
        if let photos = dictionary["photos"] as? [[String: AnyObject]] {
            if let ref = photos.first?["photo_reference"] {
                self.imageReference = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(ref)&key=\(Constant.googlePlacesKey)"
            }
        }
        
        
        let lat = (dictionary["geometry"] as! [String: [String: AnyObject]])["location"]!["lat"] as! CLLocationDegrees
        let lng = (dictionary["geometry"] as! [String: [String: AnyObject]])["location"]!["lng"] as! CLLocationDegrees
        coordinates = CLLocationCoordinate2DMake(lat, lng)
        
        if let open = dictionary["opening_hours"] as? [String: AnyObject] {
            openNow = open["open_now"] as? Bool
        }
        
    }
}
